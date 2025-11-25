output "amplify_app_id" {
  description = "Amplify App ID"
  value       = module.amplify.amplify_app_id
}

output "amplify_app_arn" {
  description = "Amplify App ARN"
  value       = module.amplify.amplify_app_arn
}

output "amplify_default_domain" {
  description = "Amplify default domain"
  value       = module.amplify.amplify_default_domain
}

output "amplify_branch_url" {
  description = "Amplify branch URL"
  value       = module.amplify.amplify_branch_url
}

output "website_url" {
  description = "Website URL"
  value       = module.amplify.website_url
}

output "amplify_webhook_url" {
  description = "Webhook URL for manual deployments"
  value       = module.amplify.amplify_webhook_url
  sensitive   = true
}

output "amplify_console_url" {
  description = "Amplify Console URL"
  value       = module.amplify.amplify_console_url
}

output "domain_association_status" {
  description = "Domain association status"
  value       = module.amplify.domain_association_status
}

