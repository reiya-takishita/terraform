# WAFv2 モジュール

最小の Web ACL（ALLOW デフォルト）を作成します。CloudFront で使う場合は `scope = "CLOUDFRONT"` を指定します。

## 使い方
```hcl
module "waf" {
  source = "../wafv2"
  name   = "app-waf"
  scope  = "REGIONAL" # or CLOUDFRONT
}
```
