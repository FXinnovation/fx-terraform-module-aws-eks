resource "random_string" "this" {
  length  = 8
  special = false
  upper   = false
  number  = false
}

module "standard" {
  source = "../../"

  iam_role_name       = random_string.this.result
  name                = random_string.this.result
  security_group_name = random_string.this.result
  subnet_ids          = tolist(data.aws_subnet_ids.default.ids)
}
