# Notifications
output "notifications_topic_arn" {
  description = "The notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

# Prometheus
output "prometheus_role_arn" {
  description = "Prometheus Role ARN"
  value       = "${aws_iam_role.prometheus.arn}"
}

# Terraform
output "terraform_role_arn" {
  description = "Terraform Role ARN"
  value       = "${aws_iam_role.terraform.arn}"
}
