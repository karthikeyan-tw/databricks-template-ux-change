resource "databricks_storage_credential" "location" {
  name = var.storage_credential

  aws_iam_role {
    role_arn = aws_iam_role.location.arn
  }
}

resource "aws_iam_role" "location" {
  name               = var.iam_role
  assume_role_policy = data.aws_iam_policy_document.trust.json
  tags               = var.tags
}

resource "aws_iam_policy_attachment" "permission" {
  name       = var.iam_role
  policy_arn = aws_iam_policy.permission.arn
  roles      = [aws_iam_role.location.name]
}

resource "aws_iam_policy" "permission" {
  name   = var.iam_role
  policy = data.aws_iam_policy_document.permission.json
  tags   = var.tags
}

data "aws_iam_policy_document" "trust" {

  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.account_id]
    }
  }

  # Alternative solution to create the self-referencing trust in a single TF apply
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_role}"]
    }
  }
}

data "aws_kms_key" "s3_encryption" {
  count  = var.s3_kms_key == null ? 0 : 1
  key_id = "alias/${var.s3_kms_key}"
}

data "aws_iam_policy_document" "permission" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration"
    ]

    resources = [
      local.s3_bucket_arn,
      "${local.s3_bucket_arn}/*",
    ]
  }

  dynamic statement {
    for_each = var.s3_kms_key == null ? [] : [1]

    content {
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey*"
      ]
      resources = [
        data.aws_kms_key.s3_encryption[0].arn
      ]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_role}"]
  }
}