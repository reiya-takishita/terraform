variable "vault_name" {
  description = "Backup vault name"
  type        = string
  default     = "default-vault"
}

variable "plan_name" {
  description = "Backup plan name"
  type        = string
  default     = "daily-backup-plan"
}
