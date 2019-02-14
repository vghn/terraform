variable "email" {
  description = "Notifications email"
}

variable "vbot_slack_alerts_webhook_url" {
  description = "The WebHook URL of the VBot #Alerts channel"
}

variable "terraform_trusted_user_arn" {
  description = "Terraform user ARN"
}

variable "puppet_secret" {
  description = "Puppet secret"
}

variable "puppetdb_user" {
  description = "PuppetDB user"
}

variable "puppetdb_pass" {
  description = "PuppetDB password"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
