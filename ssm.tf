# Notifications
data "aws_ssm_parameter" "email" {
  name = "/vgh/email"
}

# CloudFlare
data "aws_ssm_parameter" "cf_email" {
  name = "/vgh/cloudflare/email"
}

data "aws_ssm_parameter" "cf_api_key" {
  name = "/vgh/cloudflare/api_key"
}

# Slack
data "aws_ssm_parameter" "vbot_slack_alerts_hook_url" {
  name = "/vbot/SlackAlertsHookURL"
}
