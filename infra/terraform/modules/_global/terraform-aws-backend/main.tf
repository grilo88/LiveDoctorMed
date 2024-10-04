# Configure the AWS Provider
provider "aws" {
  region     = "sa-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
  retry_mode = "adaptive"  # "legacy" or "standard"
}