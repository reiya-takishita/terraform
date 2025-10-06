resource "aws_securityhub_account" "this" {
  enable_default_standards = false
  depends_on               = []
  # Enabled controlled by lifecycle: if disabled, we skip subscriptions
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each              = var.enabled ? toset(var.standards_arns) : []
  standards_arn         = each.value
  depends_on            = [aws_securityhub_account.this]
}
