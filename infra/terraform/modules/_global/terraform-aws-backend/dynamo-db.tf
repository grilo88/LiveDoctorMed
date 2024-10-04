resource "aws_dynamodb_table" "terraform_develop_locks" {
  name         = "develop-tf-lock"
  billing_mode = "PAY_PER_REQUEST"  # Modelo de pagamento para uso variável
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "Production"
  }
}

resource "aws_dynamodb_table" "terraform_prod_locks" {
  name         = "prod-tf-lock"
  billing_mode = "PAY_PER_REQUEST"  # Modelo de pagamento para uso variável
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "Production"
  }
}