# S3バケット名
variable "bucket_name" {
  description = "S3バケットの名前。グローバルで一意である必要があります。"
  type        = string
}

# S3バケットのタグ
variable "tags" {
  description = "S3バケットに割り当てるタグのマップ。"
  type        = map(string)
  default     = {}
}

# S3バケットのACL
variable "acl" {
  description = "適用するCanned ACL。有効な値は `private`, `public-read`, `public-read-write`, `aws-exec-read`, `authenticated-read`, `log-delivery-write` です。"
  type        = string
  default     = "private"
}

# バケット強制削除フラグ
variable "force_destroy" {
  description = "バケットが破棄されるときに、バケット内のすべてのオブジェクト（ロックされたオブジェクトを含む）を削除するかどうかを示します。"
  type        = bool
  default     = false
}

# パブリックACLブロック
variable "block_public_acls" {
  description = "Amazon S3がこのバケットのパブリックACLをブロックするかどうか。"
  type        = bool
  default     = true
}

# パブリックバケットポリシーブロック
variable "block_public_policy" {
  description = "Amazon S3がこのバケットのパブリックバケットポリシーをブロックするかどうか。"
  type        = bool
  default     = true
}

# パブリックACL無視
variable "ignore_public_acls" {
  description = "Amazon S3がこのバケットのパブリックACLを無視するかどうか。"
  type        = bool
  default     = true
}

# パブリックバケット制限
variable "restrict_public_buckets" {
  description = "Amazon S3がこのバケットのパブリックバケットポリシーを制限するかどうか。"
  type        = bool
  default     = true
}

# バージョン管理有効化フラグ
variable "enable_versioning" {
  description = "このバケットでバージョン管理を有効にするかどうかを示します。"
  type        = bool
  default     = false
}

# ライフサイクルルール
variable "lifecycle_rules" {
  description = "バケットのライフサイクルルールのリスト。"
  type = list(object({
    id                        = string
    status                    = string # "Enabled" or "Disabled"
    expiration_days           = number # オブジェクトを期限切れにする日数 (nullの場合、設定しない)
    transition_days           = number # オブジェクトを移行する日数 (nullの場合、設定しない)
    transition_storage_class  = string # 移行先のストレージクラス (e.g., GLACIER, STANDARD_IA) (nullの場合、設定しない)
  }))
  default = []
}

# サーバーサイド暗号化アルゴリズム
variable "sse_algorithm" {
  description = "使用するサーバーサイド暗号化アルゴリズム。有効な値は `AES256` と `aws:kms` です。"
  type        = string
  default     = "AES256a"
}

# KMSキーID
variable "sse_kms_key_id" {
  description = "`sse_algorithm` が `aws:kms` の場合のAWS Key Management Service (AWS KMS) マスターキーのARN。"
  type        = string
  default     = null
}

# アクセスログ有効化フラグ
variable "enable_logging" {
  description = "このバケットでアクセスログを有効にするかどうかを示します。"
  type        = bool
  default     = false
}

# ログ保存先バケット名
variable "target_bucket_name" {
  description = "Amazon S3がサーバーアクセスログを保存するバケットの名前。"
  type        = string
  default     = null
}

# ログオブジェクトキーのプレフィックス
variable "target_prefix" {
  description = "すべてのログオブジェクトキーのプレフィックス。"
  type        = string
  default     = null
}
