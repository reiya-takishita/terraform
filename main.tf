terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "amplify" {
  source = "./modules/amplify"

  aws_region        = var.aws_region
  project_name      = var.project_name
  environment       = var.environment
  repository_url    = var.repository_url
  repository_branch = var.repository_branch
}
