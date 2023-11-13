resource "aws_s3_bucket" "main_bucket" {
  bucket = "saas_main_bucket"
}

resource "aws_s3_bucket_acl" "main_bucket_acl" {
  bucket = aws_s3_bucket.main_bucket.id
  acl    = "private"
}