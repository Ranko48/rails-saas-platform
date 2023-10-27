resource "aws_cloudwatch_log_group" "app-log-group" {
  name_prefix       = "${var.environment}-app"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "nginx-log-group" {
  name_prefix       = "${var.environment}-nginx"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "app" {
  family = "app"
  container_definitions = <<EOF
[
  {
    "name": "app",
    "image": "${aws_ecr_repository.app.repository_url}:latest",
    "cpu": 512,
    "memoryReservation": 200,
    "essential": true,
    "environment": [
      {"name": "DOMAIN", "value": "${var.domain}"},
      {"name": "DB_PASSWORD", "value": "${var.db_password}"},
      {"name": "DB_HOST", "value": "${module.db.db_instance_address}"},
      {"name": "DB_USERNAME", "value": "${module.db.db_instance_username}"},
      {"name": "DB_NAME", "value": "${module.db.db_instance_name}"},
      {"name": "REDIS_URL", "value": "${module.redis.elasticache_replication_group_primary_endpoint_address}"},
      {"name": "SECRET_KEY_BASE", "value": "${var.secret_key}"}
    ],
    "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${var.region}",
        "awslogs-group": "${aws_cloudwatch_log_group.app-log-group.name}",
        "awslogs-stream-prefix": "ec2"
      }
    }
  },  
  {
    "name": "nginx",
    "image": "${aws_ecr_repository.nginx.repository_url}:latest",
    "memoryReservation": 128,
    "cpu": 1024,
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${var.region}",
        "awslogs-group": "${aws_cloudwatch_log_group.nginx-log-group.name}",
        "awslogs-stream-prefix": "ec2"
      }
    },
    "links": [
      "app"
    ],
    "portMappings": [
         {
           "containerPort": 80,
           "hostPort": 80
         }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "app_service" {
  name            = "app-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = 1
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  force_new_deployment = true
  load_balancer {
    target_group_arn = aws_lb_target_group.app_alb_target.arn
    container_name   = "nginx"
    container_port   = 80
  }
}

/* Compute */
locals {
  cluster_name = "${var.environment}-application-ecs"
  user_data = <<-EOT
    #!/bin/bash
    cat <<'EOF' >> /etc/ecs/ecs.config
    ECS_CLUSTER=${local.cluster_name}
    ECS_LOGLEVEL=debug
    EOF
  EOT
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  cluster_name = "${var.environment}-application-ecs"
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "${var.environment}-ecs-logs"
      }
    }
  }
  autoscaling_capacity_providers = {
    one = {
      create_before_destroy          = true
      auto_scaling_group_arn         = module.app_autoscaling.autoscaling_group_arn
      managed_termination_protection = "ENABLED"
      managed_scaling = {
        maximum_scaling_step_size = 1
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }
      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }
}


module "app_autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.5"
  name = local.cluster_name
  image_id      = var.ecs_ami_image
  instance_type = var.ecs_instance_type
  user_data     = base64encode(local.user_data)
  security_groups                 = [module.app_autoscaling_sg.security_group_id]
  ignore_desired_capacity_changes = true
  create_iam_instance_profile = true
  iam_role_name               = "${var.environment}-backend-autoscaling-role"
  iam_role_description        = "ECS role for Backend Autoscaling group"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  vpc_zone_identifier = module.vpc.private_subnets
  health_check_type   = "EC2"
  min_size            = var.app_auto_scaling_min
  max_size            = var.app_auto_scaling_max
  desired_capacity    = 1
  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }
  # Required for  managed_termination_protection = "ENABLED"
  protect_from_scale_in = true
}

module "app_autoscaling_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"
  name        = "${var.environment}-app-autoscaling-sg"
  description = "Autoscaling group security group for app autoscaling. Set to allow all HTTP traffic"
  vpc_id      = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_rules = ["all-all"]
}



