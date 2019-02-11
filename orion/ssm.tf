resource "aws_ssm_parameter" "slack_alerts_webhook_url" {
  name  = "SlackAlertsHookURL"
  type  = "SecureString"
  value = "${var.slack_alerts_webhook_url}"
  tags  = "${var.common_tags}"
}
