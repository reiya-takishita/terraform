# AWS Shield モジュール

Shield Advanced のサブスクリプション（任意）と空の保護グループを作成します。

## 使い方
```hcl
module "shield" {
  source       = "../shield"
  subscription = true # Advanced を有効化する場合
}
```
