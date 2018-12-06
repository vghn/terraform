resource "aws_iam_role" "unifi" {
  name               = "unifi"
  description        = "Unifi"
  assume_role_policy = "${data.aws_iam_policy_document.unifi_assume_role.json}"
}

data "aws_iam_policy_document" "unifi_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "unifi" {
  name   = "unifi"
  role   = "${aws_iam_role.unifi.name}"
  policy = "${data.aws_iam_policy_document.unifi_role.json}"
}

data "aws_iam_policy_document" "unifi_role" {
  statement {
    sid       = "AllowAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }

  statement {
    sid = "AllowScalingOperations"

    actions = [
      "ec2:Describe*",
      "autoscaling:Describe*",
      "autoscaling:EnterStandby",
      "autoscaling:ExitStandby",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:DescribeLoadBalancers",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowLogging"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid       = "AllowS3ListAllBuckets"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    sid     = "AllowS3AccessToAssetsBucket"
    actions = ["*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.unifi.id}",
      "arn:aws:s3:::${aws_s3_bucket.unifi.id}/*",
    ]
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
