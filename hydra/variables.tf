variable "email" {
  description = "Notifications email"
}

variable "terraform_trusted_user_arn" {
  description = "Terraform user ARN"
}

variable "cloudflare_email" {
  description = "CloudFlare EMail"
}

variable "cloudflare_api_key" {
  description = "CloudFlare API Key"
}

variable "cloudflare_zone_id" {
  description = "CloudFlare Zone ID"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = map(string)
  default     = {}
}

