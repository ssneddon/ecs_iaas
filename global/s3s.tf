resource "aws_s3_bucket" "cloudtrail-logs" {
  bucket        = "cloudtrail-s3-bucket-for-logs-ocio"
  force_destroy = true

  tags = local.global_tags
}

