resource "aws_guardduty_detector" "this" {
  enable                       = var.enabled
  finding_publishing_frequency = var.finding_publishing_frequency
}
