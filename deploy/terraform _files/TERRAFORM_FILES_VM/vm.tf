resource "aws_iam_policy" "bucket-khomp-test-remote-state_policy" {
  name        = "mateus-khomp-test-bucket-remote-state-policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0"
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "arn:aws:s3:::mateus-khomp-test-bucket-remote-state",
          "arn:aws:s3:::mateus-khomp-test-bucket-remote-state/*"
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

resource "aws_iam_instance_profile" "bucket_S3_profile" {
  name = "bucket_S3_profile"
  role = aws_iam_role.bucket_role.name
}


resource "aws_key_pair" "key" {
  key_name   = "aws-vm-key"
  public_key = file("./aws-vm-key.pub")
}

resource "aws_instance" "khomp-test-vm" {
  ami                         = "ami-0cc56294a584ac234"
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.subnet_id
  vpc_security_group_ids      = [data.terraform_remote_state.vpc.outputs.security_group_id,data.terraform_remote_state.vpc.outputs.security_group_web_id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bucket_S3_profile.id

  tags = {
    Name = "khomp-test-vm"
  }
}