terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# When use_mock_credentials = true (default), no real AWS account is needed:
# `terraform init`, `validate` and `plan` work offline with dummy keys.
# Set it to false (and provide real credentials) to run a real `apply`.
provider "aws" {
  region = var.aws_region

  access_key = var.use_mock_credentials ? "mock-access-key" : null
  secret_key = var.use_mock_credentials ? "mock-secret-key" : null

  skip_credentials_validation = var.use_mock_credentials
  skip_requesting_account_id  = var.use_mock_credentials
  skip_metadata_api_check     = var.use_mock_credentials
  skip_region_validation      = var.use_mock_credentials
}

# 1. S3 bucket to store build artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = var.bucket_name

  tags = {
    Name    = "${var.project_name}-artifacts"
    Project = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 2. Security group allowing web traffic
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP inbound and all outbound"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project_name
  }
}

# 3. EC2 web server (free-tier instance type)
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOT
    #!/bin/bash
    yum install -y docker
    systemctl enable --now docker
    docker run -d -p 80:80 nginx
  EOT

  tags = {
    Name    = "${var.project_name}-web"
    Project = var.project_name
  }
}
