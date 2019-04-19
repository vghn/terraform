# Notifications
output "notifications_topic_arn" {
  description = "The notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

# Terraform
output "terraform_role_arn" {
  description = "Terraform role ARN"
  value       = "${aws_iam_role.terraform.arn}"
}
