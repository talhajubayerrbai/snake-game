output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip
}

output "url" {
  description = "Public URL of the Snake game"
  value       = "http://${aws_instance.app.public_ip}/"
}

output "artifact_bucket" {
  description = "S3 artifact bucket name"
  value       = aws_s3_bucket.artifacts.bucket
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}
