resource "aws_s3_bucket" "main_bucket" {
  bucket = "saas-marcusrc-main-bucket"
}

resource "aws_s3_bucket_ownership_controls" "main_bucket_controls" {
  bucket = aws_s3_bucket.main_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "main_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.main_bucket_controls]
  bucket = aws_s3_bucket.main_bucket.id
  acl    = "private"
}