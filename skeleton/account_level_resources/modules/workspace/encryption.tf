resource "databricks_mws_customer_managed_keys" "workspace" {
  for_each   = { for item in var.encryption : item.name => item }
  account_id = var.account_id

  aws_key_info {
    key_arn   = aws_kms_key.customer_key[each.key].arn
    key_alias = aws_kms_alias.customer_key[each.key].name
  }

  use_cases = each.value.use_cases
}

resource "aws_kms_key" "customer_key" {
  for_each = { for item in var.encryption : item.name => item }
  policy   = data.aws_iam_policy_document.kms_policy[each.key].json

  tags = var.tags
}

resource "aws_kms_alias" "customer_key" {
  for_each      = { for item in var.encryption : item.name => item }
  name          = "alias/databricks/${var.environment}-${each.key}"
  target_key_id = aws_kms_key.customer_key[each.key].key_id
}

data "aws_iam_policy_document" "kms_policy" {
  for_each = { for item in var.encryption : item.name => item }

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = contains(each.value.use_cases, "MANAGED_SERVICES") ? [1] : []

    content {
      sid    = "Allow Databricks to use KMS key for managed services in the control plane"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::414351767826:root"] # TODO: Transfer DBX AWS account root to a constant
      }

      actions = [
        "kms:Encrypt",
        "kms:Decrypt"
      ]

      resources = ["*"]

      condition {
        test     = "StringEquals"
        variable = "aws:PrincipalTag/DatabricksAccountId"
        values   = [var.account_id]
      }

    }
  }

  dynamic "statement" {
    for_each = contains(each.value.use_cases, "STORAGE") ? [1] : []

    content {
      sid    = "Allow Databricks to use KMS key for DBFS"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::414351767826:root"] # TODO: Transfer DBX AWS account root to a constant
      }

      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]

      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = contains(each.value.use_cases, "STORAGE") ? [1] : []

    content {
      sid    = "Allow Databricks to use KMS key for DBFS (Grants)"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::414351767826:root"] # TODO: Transfer DBX AWS account root to a constant
      }

      actions = [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ]

      resources = ["*"]

      condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values   = ["true"]
      }
    }
  }

  dynamic "statement" {
    for_each = contains(each.value.use_cases, "STORAGE") ? [1] : []

    content {
      sid    = "Allow Databricks to use KMS key for EBS"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = [aws_iam_role.cross_account.arn]
      }

      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey*",
        "kms:CreateGrant",
        "kms:DescribeKey"
      ]

      resources = ["*"]

      condition {
        test     = "ForAnyValue:StringLike"
        variable = "kms:ViaService"
        values   = ["ec2.*.amazonaws.com"]
      }
    }
  }
}