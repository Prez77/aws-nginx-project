# versions.tf
terraform {
  required_version = ">= 1.0.0" # Specify your desired Terraform CLI version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify your desired AWS provider version
    }
  }
}

provider "aws" {
  region = var.aws_region # Use the AWS region defined in variables.tf
}
