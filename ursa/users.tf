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
    sid       = "AllowAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
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
    sid       = "AllowAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_access_key" "vbot_v1" {
  user = "${aws_iam_user.vbot.name}"
}
