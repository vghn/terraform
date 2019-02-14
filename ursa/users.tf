# Mini
resource "aws_iam_user" "mini" {
  name = "mini"
}

resource "aws_iam_access_key" "mini_v1" {
  user = "${aws_iam_user.mini.name}"
}

# Rhea
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

# Terraform
resource "aws_iam_user" "terraform" {
  name = "terraform"
}

resource "aws_iam_user_policy" "terraform" {
  name   = "terraform"
  user   = "${aws_iam_user.terraform.name}"
  policy = "${data.aws_iam_policy_document.terraform_user.json}"
}

data "aws_iam_policy_document" "terraform_user" {
  statement {
    sid     = "AllowAssumeRole"
    actions = ["sts:AssumeRole"]

    resources = [
      "${aws_iam_role.terraform.arn}",
      "${var.terraform_orion_role_arn}",
      "${var.terraform_mec7_role_arn}",
    ]
  }
}

resource "aws_iam_access_key" "terraform_v1" {
  user = "${aws_iam_user.terraform.name}"
}

# VBot
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
    ]
  }
}

resource "aws_iam_access_key" "vbot_v1" {
  user = "${aws_iam_user.vbot.name}"
}
