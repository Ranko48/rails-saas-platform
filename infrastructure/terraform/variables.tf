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