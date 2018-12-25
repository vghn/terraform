variable "email" {
  description = "Notifications email"
}

variable "prometheus_trusted_role_arn" {
  description = "Prometheus role ARN"
}

variable "travis_trusted_user_arn" {
  description = "Travis user ARN"
}

variable "vbot_trusted_user_arn" {
  description = "VBot User ARN"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
