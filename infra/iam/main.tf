

data "aws_caller_identity" "current" {}

locals {
  account_principal = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}


data "aws_iam_policy_document" "assume_role_same_account" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [local.account_principal]
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "admin" {
  name               = "bank-admin-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_same_account.json

  tags = {
    Name        = "bank-admin-role"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_role" "security" {
  name               = "bank-security-audit-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_same_account.json

  tags = {
    Name        = "bank-security-audit-role"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "security_attach_audit" {
  role       = aws_iam_role.security.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}


data "aws_iam_policy_document" "security_extra_read" {
  statement {
    sid     = "ReadCloudWatchLogs"
    effect  = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "security_extra_read" {
  name        = "bank-security-extra-read"
  description = "Lectura mínima de CloudWatch Logs para auditores"
  policy      = data.aws_iam_policy_document.security_extra_read.json
}

resource "aws_iam_role_policy_attachment" "security_attach_extra" {
  role       = aws_iam_role.security.name
  policy_arn = aws_iam_policy.security_extra_read.arn
}
