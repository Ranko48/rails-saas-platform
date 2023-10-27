resource "aws_security_group" "cache_to_app_sg" {
    name = "${var.environment}-cache-app"
    description = "Allow traffic from main application to cache via Redis"
    vpc_id = module.vpc.vpc_id
    revoke_rules_on_delete = true
    ingress {
        description      = "TCP from Application to Cache"
        from_port        = 6379
        to_port          = 6379
        protocol         = "tcp"
        cidr_blocks      = module.vpc.private_subnets_cidr_blocks
    }
    egress {
        description      = "TCP from Cache to Application"
        from_port        = 6379
        to_port          = 6379
        protocol         = "tcp"
        cidr_blocks      = module.vpc.private_subnets_cidr_blocks
    }
}

module "redis" {
  source = "umotif-public/elasticache-redis/aws"
  name_prefix        = "redis-main"
  num_cache_clusters = 1
  node_type          = var.redis_instance_type
  engine_version           = "7.0"
  port                     = 6379
  maintenance_window       = "mon:03:00-mon:04:00"
  snapshot_window          = "04:00-06:00"
  snapshot_retention_limit = 7
  automatic_failover_enabled = true
  multi_az_enabled           = false
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false
  apply_immediately = true
  family            = "redis7"
  description       = "Elasticache Redis for app"

  subnet_ids = [module.vpc.elasticache_subnets]
  vpc_id     = module.vpc.vpc_id

  allowed_security_groups = [aws_security_group.cache_to_app_sg.id]

  parameter = [
    {
      name  = "repl-backlog-size"
      value = "16384"
    }
  ]
}