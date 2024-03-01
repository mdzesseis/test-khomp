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

resource "aws_iam_policy" "bucket-khomp-test-remote-state_policy" {
  name        = "mateus-khomp-test-bucket-remote-state-policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::mateus-khomp-test-bucket-remote-state"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "bucket_role" {
  name = "bucket_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket-khomp-test-remote-state_bucket_policy" {
  role       = aws_iam_role.bucket_role.name
  policy_arn = aws_iam_policy.bucket-khomp-test-remote-state_policy.arn
}

resource "aws_iam_instance_profile" "bucket_profile" {
  name = "bucket-profile"
  role = aws_iam_role.bucket_role.name
}
