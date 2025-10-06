# AWS Backup モジュール

バックアップボールトとシンプルなバックアッププラン（毎日・30日保持）を作成します。

## 使い方
```hcl
module "backup" {
  source    = "../backup"
  vault_name = "default-vault"
  plan_name  = "daily-backup-plan"
}
```
