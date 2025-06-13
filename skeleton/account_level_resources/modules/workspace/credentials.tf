resource "databricks_mws_credentials" "workspace" {
  credentials_name = "${local.prefix}cross-account${local.suffix}"
  role_arn         = aws_iam_role.cross_account.arn

  depends_on = [
    time_sleep.wait
  ]
}

resource "time_sleep" "wait" {
  create_duration = "10s"

  depends_on = [
    aws_iam_role.cross_account
  ]
}

resource "aws_iam_role" "cross_account" {
  name               = "databricks-${var.environment}-cross-account-${var.region}"
  assume_role_policy = data.databricks_aws_assume_role_policy.trust_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cross_account" {
  role       = aws_iam_role.cross_account.name
  policy_arn = aws_iam_policy.cross_account.arn
}

resource "aws_iam_role_policy_attachment" "iam_pass_role" {
  role       = aws_iam_role.cross_account.name
  policy_arn = aws_iam_policy.iam_pass_role.arn
}

resource "aws_iam_policy" "cross_account" {
  name   = "databricks-${var.environment}-cross-account-${var.region}"
  policy = data.databricks_aws_crossaccount_policy.cross_account.json
  tags   = var.tags
}

resource "aws_iam_policy" "iam_pass_role" {
  name   = "databricks-${var.environment}-iam-pass-role-${var.region}"
  policy = data.aws_iam_policy_document.iam_pass_role.json
  tags   = var.tags
}

data "databricks_aws_assume_role_policy" "trust_policy" {
  external_id = var.account_id
}

data "databricks_aws_crossaccount_policy" "cross_account" {
  policy_type = var.credential.policy
}

resource "aws_iam_role_policy_attachment" "vpc_full_access" {
  role       = aws_iam_role.cross_account.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

data "aws_iam_policy_document" "iam_pass_role" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/databricks-*"]
  }
}