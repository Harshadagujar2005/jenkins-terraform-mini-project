output "bucket_name" {
  description = "S3 artifact bucket"
  value       = aws_s3_bucket.artifacts.bucket
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.web.id
}

output "instance_type" {
  description = "EC2 instance type used"
  value       = aws_instance.web.instance_type
}
