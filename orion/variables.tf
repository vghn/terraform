variable "email" {
  description = "Notifications email"
}

variable "terraform_trusted_user_arn" {
  description = "Terraform user ARN"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
