variable "email" {
  description = "Notifications email"
}

variable "travis_trusted_user_arn" {
  description = "Travis user ARN"
}

variable "vbot_trusted_user_arn" {
  description = "VBot User ARN"
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
