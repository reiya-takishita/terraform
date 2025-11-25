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
  description = "バケットのライフサイクルルールのリスト。現行バージョンおよび旧バージョンの移行と有効期限設定を定義します。"
  type = list(object({
    id     = string
    status = string # "Enabled" or "Disabled"

    # Filter for the rule (optional)
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
      # object_size_greater_than, object_size_less_than なども追加可能ですが、今回は簡易化
    }))

    # Current version expiration (optional)
    expiration = optional(object({
      days                         = optional(number)
      date                         = optional(string) # RFC3339 format (例: "2023-01-01T00:00:00Z")
      expired_object_delete_marker = optional(bool)
    }))

    # Noncurrent version expiration (optional)
    noncurrent_version_expiration = optional(object({
      noncurrent_days = number # 非現行バージョンのオブジェクトを期限切れにする日数
    }))

    # Current version transitions (optional)
    transitions = optional(list(object({
      days          = optional(number)
      date          = optional(string) # RFC3339 format
      storage_class = string # (例: GLACIER, STANDARD_IA, ONEZONE_IA, DEEP_ARCHIVE, GLACIER_IR)
    })))

    # Noncurrent version transitions (optional)
    noncurrent_version_transitions = optional(list(object({
      noncurrent_days = number # 非現行バージョンのオブジェクトを移行する日数
      storage_class   = string # (例: GLACIER, STANDARD_IA, ONEZONE_IA, DEEP_ARCHIVE, GLACIER_IR)
    })))
    # Abort incomplete multipart uploads (optional)
    abort_incomplete_multipart_upload_days = optional(number)
  }))
  default = []
}
# サーバーサイド暗号化アルゴリズム
variable "sse_algorithm" {
  description = "使用するサーバーサイド暗号化アルゴリズム。有効な値は `AES256` と `aws:kms` です。"
  type        = string
  default     = "AES256"
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
