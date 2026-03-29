terraform {
  # This ensures you are using a modern version of Terraform
  required_version = ">= 1.0" 
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # The "~> 5.0" means: Use version 5.0 or any minor update (5.1, 5.2), 
      # but NOT 6.0, to prevent breaking changes.
      version = "~> 5.0" 
    }
  }
}
provider "aws" {
  region     = var.aws_region
  }