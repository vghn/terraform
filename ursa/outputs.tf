output "notifications_topic_arn" {
  description = "Notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

# Terraform
output "terraform_user_arn" {
  description = "Terraform user ARN"
  value       = "${aws_iam_user.terraform.arn}"
}

output "terraform_access_key_id" {
  description = "Terraform access key id"
  value       = "${aws_iam_access_key.terraform_v1.id}"
}

output "terraform_secret_access_key" {
  description = "Terraform secret access key"
  value       = "${aws_iam_access_key.terraform_v1.secret}"
}

output "terraform_role_arn" {
  description = "Terraform role ARN"
  value       = "${aws_iam_role.terraform.arn}"
}

# VBot
output "vbot_user_arn" {
  description = "VBot user ARN"
  value       = "${aws_iam_user.vbot.arn}"
}

output "vbot_access_key_id" {
  description = "VBot access key id"
  value       = "${aws_iam_access_key.vbot_v1.id}"
}

output "vbot_secret_access_key" {
  description = "VBot secret access key"
  value       = "${aws_iam_access_key.vbot_v1.secret}"
}

output "vbot_role_arn" {
  description = "VBot role ARN"
  value       = "${aws_iam_role.vbot.arn}"
}
