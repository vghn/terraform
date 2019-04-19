variable "email" {
  description = "Notifications email"
}

variable "terraform_trusted_user_arn" {
  description = "Terraform user ARN"
}

variable "cf_email" {
  description = "CloudFlare EMail"
}

variable "cf_token" {
  description = "CloudFlare API Key"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
