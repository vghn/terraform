variable "email" {
  description = "Notifications email"
}

variable "prometheus_trusted_role_arn" {
  description = "Prometheus role ARN"
}

variable "prometheus_role_id" {
  description = "Prometheus role id"
}

variable "travis_orion_role_arn" {
  description = "TravisCI role ARN for Orion"
}

variable "travis_mec7_role_arn" {
  description = "TravisCI role ARN for MEC7"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = "map"
  default     = {}
}
