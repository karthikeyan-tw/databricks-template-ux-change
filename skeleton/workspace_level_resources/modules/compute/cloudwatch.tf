resource "databricks_workspace_file" "cw_agent" {
  count  = var.monitoring.cloudwatch ? 1 : 0
  source = "${path.module}/monitoring/cloudwatch-init.sh"
  path   = "/Shared/monitoring/cloudwatch-init.sh"
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  for_each   = { for item in var.clusters : item.name => item if var.monitoring.cloudwatch }
  role       = aws_iam_role.compute[each.key].name
  policy_arn = data.aws_iam_policy.cw_agent_server.arn
}

resource "aws_iam_role_policy_attachment" "describe_tags" {
  for_each   = { for item in var.clusters : item.name => item if var.monitoring.cloudwatch }
  role       = aws_iam_role.compute[each.key].name
  policy_arn = aws_iam_policy.describe_tags[0].arn
}

data "aws_iam_policy" "cw_agent_server" {
  name = "CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy" "describe_tags" {
  count  = var.monitoring.cloudwatch ? 1 : 0
  name   = "databricks-${var.environment}-describe-tags-${var.region}"
  policy = data.aws_iam_policy_document.describe_tags.json
  tags   = var.tags
}

data "aws_iam_policy_document" "describe_tags" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeTags"]
    resources = ["*"]
  }
}