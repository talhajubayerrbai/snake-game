variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "service_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "snake-game"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "Port the Node.js app listens on"
  type        = number
  default     = 8080
}

variable "github_repo" {
  description = "GitHub repository (owner/repo) to clone"
  type        = string
  default     = "talhajubayerrbai/snake-game"
}
