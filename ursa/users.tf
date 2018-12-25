resource "aws_iam_user" "mini" {
  name = "mini"
}

resource "aws_iam_access_key" "mini_v1" {
  user = "${aws_iam_user.mini.name}"
}

resource "aws_iam_user" "rhea" {
  name = "rhea"
}

resource "aws_iam_user_policy" "rhea" {
  user   = "${aws_iam_user.rhea.id}"
  name   = "rhea"
  policy = "${data.aws_iam_policy_document.rhea_user.json}"
}

data "aws_iam_policy_document" "rhea_user" {
  statement {
    sid       = "AllowEC2Listing"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  statement {
    sid       = "AllowGettingPuppetParameters"
    actions   = ["ssm:Get*"]
    resources = ["arn:aws:ssm:*:*:parameter/puppet/*"]
  }
}

resource "aws_iam_access_key" "rhea_v1" {
  user = "${aws_iam_user.rhea.name}"
}

resource "aws_iam_user" "travis" {
  name = "travis"
}

resource "aws_iam_user_policy" "travis" {
  name   = "travis"
  user   = "${aws_iam_user.travis.name}"
  policy = "${data.aws_iam_policy_document.travis_user.json}"
}

data "aws_iam_policy_document" "travis_user" {
  statement {
    sid     = "AllowAssumeRole"
    actions = ["sts:AssumeRole"]

    resources = [
      "${aws_iam_role.travis.arn}",
      "${var.travis_orion_role_arn}",
      "${var.travis_mec7_role_arn}",
    ]
  }
}

resource "aws_iam_access_key" "travis_v1" {
  user = "${aws_iam_user.travis.name}"
}

resource "aws_iam_user" "vbot" {
  name = "vbot"
}

resource "aws_iam_user_policy" "vbot" {
  name   = "vbot"
  user   = "${aws_iam_user.vbot.name}"
  policy = "${data.aws_iam_policy_document.vbot_user.json}"
}

data "aws_iam_policy_document" "vbot_user" {
  statement {
    sid     = "AllowAssumeRole"
    actions = ["sts:AssumeRole"]

    resources = [
      "${aws_iam_role.vbot.arn}",
      "${var.vbot_orion_role_arn}",
      "${var.vbot_mec7_role_arn}",
    ]
  }
}

resource "aws_iam_access_key" "vbot_v1" {
  user = "${aws_iam_user.vbot.name}"
}
