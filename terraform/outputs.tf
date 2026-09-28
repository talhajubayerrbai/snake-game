output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_url" {
  description = "Public URL of the Snake game"
  value       = "http://${aws_lb.main.dns_name}/"
}
