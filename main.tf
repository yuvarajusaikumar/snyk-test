provider "aws" {
  region = "us-west-2"
}

# Create an S3 bucket for file storage
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-12345"
  acl    = "private"
}

# Create a security group for EC2 instance
resource "aws_security_group" "example_sg" {
  name        = "example_sg"
  description = "Allow inbound HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # This is a potential security issue!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance using the security group and S3 bucket
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example AMI ID, replace with valid one
  instance_type = "t2.micro"
  security_groups = [aws_security_group.example_sg.name]

  tags = {
    Name = "ExampleInstance"
  }
}
