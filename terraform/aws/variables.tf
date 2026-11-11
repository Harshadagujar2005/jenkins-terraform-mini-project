variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "use_mock_credentials" {
  description = "true = dummy credentials (plan only, no AWS account needed). false = use real credentials."
  type        = bool
  default     = true
}

variable "project_name" {
  description = "Prefix used for resource names and tags"
  type        = string
  default     = "mini-cicd"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name (change this before a real apply)"
  type        = string
  default     = "mini-cicd-project-harshada"
}

variable "ami_id" {
  description = "Amazon Linux AMI ID for your region (look it up in the EC2 console before a real apply)"
  type        = string
  default     = "ami-05fbd65e334e88c16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
