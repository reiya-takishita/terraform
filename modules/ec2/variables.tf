variable "name_prefix" {
  description = "各リソース名のプレフィックス"
  type        = string
}

variable "subnet_id" {
  description = "EC2を配置するサブネットID"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "EC2に付与するセキュリティグループID一覧"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2インスタンスタイプ"
  type        = string
  default     = "t3.micro"
}


