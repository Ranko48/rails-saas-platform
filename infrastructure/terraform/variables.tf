variable "domain" {
    description = "Domain"
    type = string
}

variable "aws_access_key_id" {
    description = "AWS Access Key id"
    type = string
    sensitive = true
}

variable "aws_secret_access_key" {
    description = "AWS Secret Access key"
    type = string
    sensitive = true
}

variable "environment" {
    description = "Environment name, e.g. dev, qa, prod"
    type = string
    default = "dev"
}

variable "rds_instance_type" {
    description = "Instance type used by RDS"
    type = string
    default = "db.t3.micro"
}

variable "db_password" {
    description = "Password for primary postgres database"
    type = string
    sensitive = true
}

variable "app_auto_scaling_min" {
    description = "Minimum ec2 instances for app auto-scaling group"
    type = string
    default = 1
}

variable "app_auto_scaling_max" {
    description = "Maximum ec2 instances for app auto-scaling group"
    type = string
    default = 1
}

variable "ecs_ami_image" {
    description = "AMI used for EC2 instances on ECS"
    type = string
    default = "ami-005b5f3941c234694"
}

variable "ecs_instance_type" {
    description = "Instance type used by ECS cluster"
    type = string
    