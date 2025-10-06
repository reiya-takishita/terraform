resource "aws_cloudtrail" "this" {
  name                          = var.name
  s3_bucket_name                = var.bucket_name
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  is_organization_trail         = false

  dynamic "cloud_watch_logs_group_arn" {
    for_each = var.cloudwatch_logs_group_arn == null ? [] : [var.cloudwatch_logs_group_arn]
    content  = cloud_watch_logs_group_arn.value
  }
}
