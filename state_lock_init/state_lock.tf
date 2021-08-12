resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-s3-bucket-for-state-lock-ocio"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = false
  }

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-s3-bucket-for-state-lock-ocio"
    key            = "state-lock/terraform.tfstate"
    region         = "us-east-1"

    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}