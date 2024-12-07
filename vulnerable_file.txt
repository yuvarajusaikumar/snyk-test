provider "aws" {
  region = "us-east-1"
}

# Insecure Security Group Configuration (High Risk)
resource "aws_security_group" "example" {
  name        = "example_sg"
  description = "Allow open access to all ports"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # This allows access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open egress to anywhere as well
  }
}

# Insecure IAM Policy (High Risk)
resource "aws_iam_policy" "example_policy" {
  name        = "example-policy"
  description = "Allow full access to all resources in the AWS account"
  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action   = "s3:*"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::*"
      },
      {
        Action   = "ec2:*"
        Effect   = "Allow"
        Resource = "arn:aws:ec2:::*"
      }
    ]
  })
}

# Insecure EC2 Instance Launch Configuration (Medium Risk)
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Sample AMI ID (may not be secure)
  instance_type = "t2.micro"
  key_name      = "my-key"  # If key_name is used, SSH access is allowed from anywhere

  security_groups = ["${aws_security_group.example.name}"]  # Attaching the open security group

  tags = {
    Name = "example-instance"
  }
}

# Insecure S3 Bucket (High Risk)
resource "aws_s3_bucket" "example" {
  bucket = "my-insecure-bucket-example"
  acl    = "public-read"  # This exposes the S3 bucket publicly
}

# Exposing Sensitive Information (Medium Risk)
output "instance_public_ip" {
  value = aws_instance.example.public_ip  # Exposes the public IP in Terraform output, which can be a security risk
}
