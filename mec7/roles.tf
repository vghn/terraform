# Terraform Role
resource "aws_iam_role" "terraform" {
  name               = "terraform"
  description        = "Terraform"
  assume_role_policy = data.aws_iam_policy_document.terraform_trust.json
}

data "aws_iam_policy_document" "terraform_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.terraform_trusted_user_arn]
    }
  }
}

resource "aws_iam_role_policy_attachment" "administrator_access" {
  role       = aws_iam_role.terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

