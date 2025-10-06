variable "enabled" {
  description = "Whether to enable GuardDuty detector"
  type        = bool
  default     = true
}

variable "finding_publishing_frequency" {
  description = "Finding publishing frequency: FIFTEEN_MINUTES | ONE_HOUR | SIX_HOURS"
  type        = string
  default     = "FIFTEEN_MINUTES"
}
