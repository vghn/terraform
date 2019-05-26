variable "name" {
  description = "Name to use for resources"
  type        = string
  default     = "cloudwatch-event-watcher"
}

variable "common_tags" {
  description = "Tags that should be applied to all resources"
  type        = map(string)
  default     = {}
}

