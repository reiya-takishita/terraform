variable "enabled" {
  description = "Whether to enable Security Hub"
  type        = bool
  default     = true
}

variable "standards_arns" {
  description = "List of Security Hub standards ARNs to subscribe"
  type        = list(string)
  default     = []
}
