resource "aws_s3_bucket" "terraform_state" {
  bucket = "livedoctormed-terraform-backend"
  force_destroy       = false
  object_lock_enabled = true
  
  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "versioning_backend_terraform" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}