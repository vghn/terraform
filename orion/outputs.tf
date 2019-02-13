# Notifications
output "notifications_topic_arn" {
  description = "The notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

# PuppetDB
output "puppetdb_instance_address" {
  description = "The address of the PuppetDB RDS instance"
  value       = "${module.puppetdb.this_db_instance_address}"
}

# Prometheus instance
output "prometheus_instance_public_ip" {
  description = "The IP address of the Prometheus instance"
  value       = "${aws_eip.prometheus.public_ip}"
}

output "prometheus_instance_public_dns" {
  description = "The DNS address of the Prometheus instance"
  value       = "${data.null_data_source.prometheus.outputs["public_dns"]}"
}

# Prometheus role
output "prometheus_role_arn" {
  description = "The Prometheus role ARN"
  value       = "${aws_iam_role.prometheus.arn}"
}

output "prometheus_role_id" {
  description = "The Prometheus role id"
  value       = "${aws_iam_role.prometheus.unique_id}"
}

# TravisCI
output "travis_role_arn" {
  description = "TravisCI Role ARN"
  value       = "${aws_iam_role.travis.arn}"
}
