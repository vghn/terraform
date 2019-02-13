resource "aws_ssm_parameter" "vbot_slack_alerts_webhook_url" {
  name  = "/vbot/SlackAlertsHookURL"
  type  = "SecureString"
  value = "${var.vbot_slack_alerts_webhook_url}"
  tags  = "${var.common_tags}"
}
