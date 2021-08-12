resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = data.aws_s3_bucket.cloudtrail_logs.id
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${data.aws_s3_bucket.cloudtrail_logs.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${data.aws_s3_bucket.cloudtrail_logs.arn}/${var.project}_${var.environment}_logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOT

}

resource "aws_cloudtrail" "ecs_cloudtrail" {
  name                          = "${var.project}_${var.environment}_cloudtrail"
  s3_bucket_name                =  data.aws_s3_bucket.cloudtrail_logs.id
  s3_key_prefix                 = "${var.project}_${var.environment}_logs"
  include_global_service_events = false
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail-cw-logs.arn}:*"
  cloud_watch_logs_role_arn     = var.cloudtrail_role_arn

  tags = var.project_tags
}

resource "aws_cloudwatch_log_group" "cloudtrail-cw-logs" {
  name = "${var.project}_${var.environment}-cloudtrail-cw-logs"

  tags = var.project_tags
}
