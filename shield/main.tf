resource "aws_shield_protection_group" "default" {
  protection_group_id = "default-empty"
  aggregation         = "SUM"
  members             = []
  pattern             = "ARBITRARY"
}

resource "aws_shield_subscription" "adv" {
  count = var.subscription ? 1 : 0
}
