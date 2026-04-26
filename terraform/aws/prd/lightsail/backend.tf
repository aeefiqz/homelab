terraform {
  required_version = ">= 1.10.0"
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.80.0"
        }
    }
    backend "s3" {
        encrypt        = true
        bucket         = "homelab-prd-terraform-state"
        key            = "terraform/lightsail/terraform.tfstate"
        region         = "ap-southeast-1"
        dynamodb_table = "terraform-locks"
    }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}


