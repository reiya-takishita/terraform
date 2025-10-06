# Macie モジュール

Amazon Macie を有効化します。

## 使い方
```hcl
module "macie" {
  source = "../macie"
  status = "ENABLED" # or "PAUSED"
}
```
