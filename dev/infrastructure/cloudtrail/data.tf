data "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-s3-bucket-for-logs-ocio"
}

data "aws_caller_identity" "current" {}
