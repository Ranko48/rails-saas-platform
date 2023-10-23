resource "aws_ecr_repository" "app" {
    name  = "app"
}

resource "aws_ecr_repository" "nginx" {
    name  = "nginx"
}