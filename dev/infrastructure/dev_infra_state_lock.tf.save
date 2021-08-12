terraform {
backend "s3" {
bucket = "terraform-s3-bucket-for-state-lock-ocio"
key = "hhsaspa/dev/infra/terraform.tfstate"
region = "us-east-1"
dynamodb_table = "terraform-state-lock"
encrypt = true
}
}

