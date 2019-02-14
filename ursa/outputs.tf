output "notifications_topic_arn" {
  description = "The notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

output "mini_user_arn" {
  description = "Mini user ARN"
  value       = "${aws_iam_user.mini.arn}"
}

output "mini_access_key_id" {
  description = "Mini access key id"
  value       = "${aws_iam_access_key.mini_v1.id}"
}

output "mini_secret_access_key" {
  description = "Mini secret access key"
  value       = "${aws_iam_access_key.mini_v1.secret}"
}

output "rhea_user_arn" {
  description = "Rhea user ARN"
  value       = "${aws_iam_user.rhea.arn}"
}

output "rhea_access_key_id" {
  description = "Rhea access key id"
  value       = "${aws_iam_access_key.rhea_v1.id}"
}

output "rhea_secret_access_key" {
  description = "Rhea secret access key"
  value       = "${aws_iam_access_key.rhea_v1.secret}"
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
  description = "Terraform Role ARN"
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
  description = "VBot Role ARN"
  value       = "${aws_iam_role.vbot.arn}"
}

output "prometheus_role_arn" {
  description = "Promethesu role ARN"
  value       = "${aws_iam_role.prometheus.arn}"
}
