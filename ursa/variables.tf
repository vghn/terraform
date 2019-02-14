variable "email" {
  description = "Notifications email"
}

variable "prometheus_trusted_role_arn" {
  description = "Prometheus role ARN"
}

variable "prometheus_role_id" {
  description = "Prometheus role id"
}

variable "terraform_orion_role_arn" {
  description = "Terraform role ARN for Orion"
}

variable "terraform_mec7_role_arn" {
  description = "Terraform role ARN for MEC7"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
