terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    # bucket, key, region and use_lockfile are supplied via -backend-config at init time
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}
