output "macie_status" {
  description = "Macie status"
  value       = aws_macie2_account.this.status
}
