terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}