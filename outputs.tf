# Event Bridge Domain Bus
output "eventbridge_domain_bus_name" {
  description = "Domain EventBridge Bus name"
  value       = var.domain_bus_name
}

output "eventbridge_domain_bus_arn" {
  description = "Domain Event Bridge Bus ARN"
  value       = aws_cloudwatch_event_bus.this.arn
}

output "eventbridge_rule_ids" {
  description = "Event Bridge Rule IDs"
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => v.id }
}

output "eventbridge_rule_arns" {
  description = "Event Bridge Rule ARNs"
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => v.arn }
}

output "eventbridge_iam_role_name" {
  description = "IAM Role name for the domain bus to forward events to local bus"
  value       = aws_iam_role.domain_bus_invoke_local_event_buses.name
}

output "eventbridge_iam_role_arn" {
  description = "IAM Role ARN for the local bus to forward events to sqs"
  value       = aws_iam_role.domain_bus_invoke_local_event_buses.arn
}
