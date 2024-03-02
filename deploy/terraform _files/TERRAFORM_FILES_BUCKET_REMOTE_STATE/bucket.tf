resource "aws_s3_bucket" "bucket-khomp-test-remote-state" {
  bucket        = "mateus-khomp-test-bucket-remote-state"
  force_destroy = true
  tags = {
    owner      = "khmop-test"
    managed-by = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket-khomp-test-remote-state.id
  versioning_configuration {
    status = "Enabled"
  }
}
