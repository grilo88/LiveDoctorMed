terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67"
    }
  }

  backend "s3" {
    bucket         = "livedoctormed-terraform-backend"
    key            = "develop/aws-useast1.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "develop-tf-lock"
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  retry_mode = "adaptive" # "legacy" or "standard"
}