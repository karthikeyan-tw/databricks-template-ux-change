locals {
  iam = {
    for item in var.clusters : item.name => {
      name = lower(replace(replace(item.name, "_", "-"), " ", "-")) # Replace underscore and space by hyphen
    }
  }
}

resource "databricks_instance_profile" "compute" {
  for_each             = { for item in var.clusters : item.name => item }
  instance_profile_arn = aws_iam_instance_profile.compute[each.key].arn
  iam_role_arn         = aws_iam_role.compute[each.key].arn
  skip_validation      = true
}

resource "aws_iam_instance_profile" "compute" {
  for_each = { for item in var.clusters : item.name => item }
  name     = "databricks-${var.environment}-compute-${local.iam[each.key].name}"
  role     = aws_iam_role.compute[each.key].name

  tags = var.tags
}

resource "aws_iam_role" "compute" {
  for_each           = { for item in var.clusters : item.name => item }
  name               = "databricks-${var.environment}-compute-${local.iam[each.key].name}-${var.region}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_policy.json

  tags = var.tags
}

data "aws_iam_policy_document" "ec2_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
