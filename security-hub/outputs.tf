output "standards_subscriptions" {
  description = "Subscribed Security Hub standards"
  value       = [for s in aws_securityhub_standards_subscription.this : s.standards_arn]
}
