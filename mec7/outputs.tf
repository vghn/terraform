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

# TravisCI
output "travis_role_arn" {
  description = "TravisCI Role ARN"
  value       = "${aws_iam_role.travis.arn}"
}
