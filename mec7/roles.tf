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
    resources = ["arn:aws:ssm:*:*:parameter/mec7/*"]
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

# TravisCI Role
resource "aws_iam_role" "travis" {
  name               = "travis"
  description        = "TravisCI"
  assume_role_policy = "${data.aws_iam_policy_document.travis_assume_role.json}"
}

data "aws_iam_policy_document" "travis_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${var.travis_trusted_user_arn}"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = "${aws_iam_role.travis.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
