variable "aws_region" {
  description = "AWSリージョン"
  type        = string
}

variable "project_name" {
  description = "リソース名のプレフィックス"
  type        = string
}

variable "environment" {
  description = "Environment (dev, stg, prod)"
  type        = string
}

variable "repository_url" {
  description = "Git repository URL (GitHub, GitLab, Bitbucket, CodeCommit)"
  type        = string
}

variable "repository_branch" {
  description = "Git branch to deploy"
  type        = string
}

variable "github_access_token" {
  description = "GitHub personal access token (required for GitHub repositories)"
  type        = string
  sensitive   = true
  default     = "your-github-access-token"
}

variable "build_spec" {
  description = "Base build specification (without appRoot)"
  type        = string
  default     = <<-EOT
version: 1
applications:
  - frontend:
      phases:
        preBuild:
          commands:
            - export NODE_OPTIONS=--openssl-legacy-provider
            - yarn install --frozen-lockfile || yarn install
        build:
          commands:
            - yarn build
      artifacts:
        baseDirectory: .next
        files:
          - '**/*'
      cache:
        paths:
          - .next/cache/**/*
          - node_modules/**/*
EOT
}

variable "framework" {
  description = "Frontend framework (react, vue, angular, nextjs, etc.). Leave empty for auto-detection."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Custom domain name"
  type        = string
  default     = ""
}

variable "enable_auto_branch_creation" {
  description = "Enable automatic branch creation"
  type        = bool
  default     = false
}

variable "auto_branch_creation_patterns" {
  description = "Patterns for automatic branch creation"
  type        = list(string)
  default     = ["feature/*", "dev"]
}

variable "platform" {
  description = "Platform (WEB_COMPUTE for SSR, WEB for static)"
  type        = string
  default     = "WEB_COMPUTE"
}

variable "stage" {
  description = "Stage (PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL)"
  type        = string
  default     = "DEVELOPMENT"
}

variable "enable_basic_auth" {
  description = "Enable basic authentication"
  type        = bool
  default     = false
}

variable "basic_auth_username" {
  description = "Basic auth username"
  type        = string
  default     = ""
}

variable "basic_auth_password" {
  description = "Basic auth password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "environment_variables" {
  description = "Environment variables for build"
  type        = map(string)
  default     = {environment = "development"}
  sensitive   = true
}

variable "enable_notifications" {
  description = "Enable build notifications"
  type        = bool
  default     = true
}

variable "notification_email" {
  description = "Email for build notifications"
  type        = string
  default     = "your-email@example.com"
}

variable "custom_rules" {
  description = "Custom rewrite and redirect rules"
  type = list(object({
    source    = string
    target    = string
    status    = string
    condition = string
  }))
  default = []
}

