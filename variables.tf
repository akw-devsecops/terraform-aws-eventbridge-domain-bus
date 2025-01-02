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
    consumer_service = string
    target_bus_arn   = string
    event_subscriptions = map(object({
      event_type    = string
      event_version = string
    }))
  }))
  default = {}
}
