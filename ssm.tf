# Notifications
data "aws_ssm_parameter" "email" {
  name = "/vgh/email"
}

# Slack
data "aws_ssm_parameter" "vbot_slack_alerts_webhook_url" {
  name = "/vbot/SlackAlertsHookURL"
}

# CloudFlare
data "aws_ssm_parameter" "cf_email" {
  name = "/cloudflare/email"
}

data "aws_ssm_parameter" "cf_token" {
  name = "/cloudflare/token"
}

data "aws_ssm_parameter" "cosmin_cf_email" {
  name = "/cosmin/cloudflare/email"
}

data "aws_ssm_parameter" "cosmin_cf_token" {
  name = "/cosmin/cloudflare/token"
}
