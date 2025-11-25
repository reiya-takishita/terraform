output "amplify_app_id" {
  description = "Amplify App ID"
  value       = aws_amplify_app.main.id
}

output "amplify_app_arn" {
  description = "Amplify App ARN"
  value       = aws_amplify_app.main.arn
}

output "amplify_default_domain" {
  description = "Amplify default domain"
  value       = aws_amplify_app.main.default_domain
}

output "amplify_branch_url" {
  description = "Amplify branch URL"
  value       = "https://${var.repository_branch}.${aws_amplify_app.main.default_domain}"
}

output "website_url" {
  description = "Website URL"
  value       = var.domain_name != "" ? "https://${var.domain_name}" : "https://${var.repository_branch}.${aws_amplify_app.main.default_domain}"
}

output "amplify_webhook_url" {
  description = "Webhook URL for manual deployments"
  value       = aws_amplify_webhook.main.url
  sensitive   = true
}

output "amplify_console_url" {
  description = "Amplify Console URL"
  value       = "https://console.aws.amazon.com/amplify/home?region=${var.aws_region}#/${aws_amplify_app.main.id}"
}

output "domain_association_status" {
  description = "Domain association status"
  value       = var.domain_name != "" ? aws_amplify_domain_association.main[0].certificate_verification_dns_record : null
}

