variable "email" {
  description = "Notifications email"
}

variable "vbot_slack_alerts_webhook_url" {
  description = "The WebHook URL of the VBot #Alerts channel"
}

variable "prometheus_trusted_role_arn" {
  description = "Prometheus role ARN"
}

variable "travis_trusted_user_arn" {
  description = "Travis user ARN"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
