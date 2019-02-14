# Prometheus
resource "aws_iam_role" "prometheus" {
  name               = "prometheus"
  description        = "Prometheus"
  assume_role_policy = "${data.aws_iam_policy_document.prometheus_assume_role.json}"
}

data "aws_iam_policy_document" "prometheus_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${var.prometheus_trusted_role_arn}"]
    }
  }
}

resource "aws_iam_role_policy" "prometheus" {
  role   = "${aws_iam_role.prometheus.id}"
  name   = "prometheus"
  policy = "${data.aws_iam_policy_document.prometheus_role.json}"
}

data "aws_iam_policy_document" "prometheus_role" {
  # AWS SSM Parameter Store
  statement {
    sid       = "AllowListingParameters"
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }

  statement {
    sid       = "AllowGettingParameters"
    actions   = ["ssm:Get*"]
    resources = ["arn:aws:ssm:*:*:parameter/prometheus/*"]
  }

  # Grafana
  statement {
    sid = "AllowReadingMetricsFromCloudWatch"

    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricStatistics",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowReadingTagsFromEC2"

    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
    ]

    resources = ["*"]
  }
}

# Terraform
resource "aws_iam_role" "terraform" {
  name               = "terraform"
  description        = "Terraform"
  assume_role_policy = "${data.aws_iam_policy_document.terraform_assume_role.json}"
}

data "aws_iam_policy_document" "terraform_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.terraform.arn}"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "terraform_administrator_access" {
  role       = "${aws_iam_role.terraform.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# VBot
resource "aws_iam_role" "vbot" {
  name               = "vbot"
  description        = "VBot"
  assume_role_policy = "${data.aws_iam_policy_document.vbot_assume_role.json}"
}

data "aws_iam_policy_document" "vbot_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.vbot.arn}"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "vbot" {
  role       = "${aws_iam_role.vbot.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
