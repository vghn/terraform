output "notifications_topic_arn" {
  description = "The notifications topic ARN"
  value       = "${module.notifications.topic_arn}"
}

output "unifi_instance_public_ip" {
  description = "The IP address of the Unifi instance"
  value       = "${aws_eip.unifi.public_ip}"
}

output "unifi_instance_public_dns" {
  description = "The DNS address of the Unifi instance"
  value       = "${data.null_data_source.unifi.outputs["public_dns"]}"
}

output "travis_role_arn" {
  description = "The TravisCI role ARN"
  value       = "${aws_iam_role.travis.arn}"
}

output "travis_role_id" {
  description = "The TravisCI role id"
  value       = "${aws_iam_role.travis.unique_id}"
}
