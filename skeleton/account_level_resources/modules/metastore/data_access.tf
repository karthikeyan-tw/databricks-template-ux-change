locals {
  iam = {
    name = "databricks-metastore-${var.region}"
  }
}

resource "databricks_metastore_data_access" "metastore" {
  count        = var.metastore.storage.enabled ? 1 : 0
  metastore_id = databricks_metastore.metastore.id
  name         = "metastore-credential-${var.region}"

  aws_iam_role {
    role_arn = aws_iam_role.metastore[0].arn
  }

  is_default = true
}

resource "aws_iam_role" "metastore" {
  count = var.metastore.storage.enabled ? 1 : 0
  name  = local.iam.name

  assume_role_policy = data.aws_iam_policy_document.metastore_trust[0].json

  tags = var.tags
}

resource "aws_iam_policy_attachment" "metastore_permission" {
  count      = var.metastore.storage.enabled ? 1 : 0
  name       = local.iam.name
  policy_arn = aws_iam_policy.metastore_permission[0].arn
  roles      = [aws_iam_role.metastore[0].name]
}

resource "aws_iam_policy" "metastore_permission" {
  count  = var.metastore.storage.enabled ? 1 : 0
  name   = local.iam.name
  policy = data.aws_iam_policy_document.metastore_permission[0].json

  tags = var.tags
}

data "aws_iam_policy_document" "metastore_trust" {
  count = var.metastore.storage.enabled ? 1 : 0

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
      values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.iam.name}"]
    }
  }
}

data "aws_iam_policy_document" "metastore_permission" {
  count = var.metastore.storage.enabled ? 1 : 0

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
      aws_s3_bucket.metastore[0].arn,
      "${aws_s3_bucket.metastore[0].arn}/*",
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.iam.name}"]
  }
}