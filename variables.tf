variable "domain_bus_name" {
  description = "A unique name for your EventBridge Bus"
  type        = string
}

variable "publishers" {
  description = "All publishers (ARNs) which needs to publish events on central domain bus"
  type = map(object({
    iam_role_arn = string
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "subscribers" {
  description = "Event subscriptions"
  type = map(object({
    target_bus_arn = string
    event_subscriptions = map(object({
      event_type   = string
      extra_filter = optional(any)
    }))
  }))
  default = {}
}

variable "env" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "Environment must be one of 'dev', 'test', or 'prod'."
  }
}

variable "ops_channel_webhook_url" {
  description = "Ops channel webhook URL"
  type        = string
  validation {
    condition     = can(regex("^https://chat.googleapis.com/v1/spaces/.*", var.ops_channel_webhook_url))
    error_message = "Ops channel webhook URL must be a valid Google Chat webhook URL."
  }
}
