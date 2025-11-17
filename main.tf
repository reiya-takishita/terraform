terraform {
  required_version = ">= 1.5.0"

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

module "network" {
  source = "./modules/vpc"

  name_prefix = var.project_name
  cidr_block  = var.vpc_cidr
}

module "web_server" {
  source = "./modules/ec2"

  name_prefix        = var.project_name
  subnet_id          = module.network.public_subnet_id
  vpc_security_group_ids = [module.network.default_sg_id]
  instance_type      = var.web_instance_type
}

output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID"
}

output "web_instance_public_ip" {
  value       = module.web_server.public_ip
  description = "WebサーバーEC2のパブリックIP"
}


