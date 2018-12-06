variable "email" {
  description = "Notifications email"
}

variable "travis_trusted_user_arn" {
  description = "Travis user ARN"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}

variable "cf_email" {
  description = "CloudFlare EMail"
}

variable "cf_token" {
  description = "CloudFlare Token"
}
