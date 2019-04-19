# Notifications
output "notifications_topic_arn" {
  description = "Notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

# Terraform
output "terraform_role_arn" {
  description = "Terraform role ARN"
  value       = "${aws_iam_role.terraform.arn}"
}

# Prometheus instance
output "prometheus_instance_public_ip" {
  description = "Prometheus instance IP address"
  value       = "${aws_eip.prometheus.public_ip}"
}

output "prometheus_instance_public_dns" {
  description = "Prometheus instance DNS address"
  value       = "${data.null_data_source.prometheus.outputs["public_dns"]}"
}
