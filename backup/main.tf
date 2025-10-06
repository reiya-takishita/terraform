resource "aws_backup_vault" "this" {
  name = var.vault_name
}

resource "aws_backup_plan" "this" {
  name = var.plan_name

  rule {
    rule_name         = "daily"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 5 * * ? *)" # 毎日 14:00JST 相当（リージョンのタイムゾーンで差異あり）
    lifecycle {
      delete_after = 30
    }
  }
}
