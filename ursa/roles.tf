# Terraform
resource "aws_iam_role" "terraform" {
  name               = "terraform"
  description        = "Terraform"
  assume_role_policy = "${data.aws_iam_policy_document.terraform_trust.json}"
}

data "aws_iam_policy_document" "terraform_trust" {
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
  assume_role_policy = "${data.aws_iam_policy_document.vbot_trust.json}"
}

data "aws_iam_policy_document" "vbot_trust" {
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
