# create one domain bus
resource "aws_cloudwatch_event_bus" "this" {
  name = var.domain_bus_name

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  count = var.publishers != null && length(var.publishers) > 0 ? 1 : 0
  statement {
    sid    = "Publisher"
    effect = "Allow"

    actions = ["events:PutEvents"]

    resources = [aws_cloudwatch_event_bus.this.arn]

    principals {

      type        = "AWS"
      identifiers = [for p in var.publishers : p.iam_role_arn]
    }
  }
}

# create policy for domain bus
resource "aws_cloudwatch_event_bus_policy" "this" {
  count          = var.publishers != null && length(var.publishers) > 0 ? 1 : 0
  event_bus_name = aws_cloudwatch_event_bus.this.name
  policy         = data.aws_iam_policy_document.this[0].json
}

# create rules for local bus
resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for sub in local.domain_subscriptions : "${sub.name}-${sub.domain}" => sub }

  event_bus_name = aws_cloudwatch_event_bus.this.arn

  name          = "${each.value.name}-${each.value.domain}"
  description   = each.value.description
  event_pattern = each.value.event_pattern
  role_arn      = aws_iam_role.domain_bus_invoke_local_event_buses.arn
}

# create targets for domain bus
resource "aws_cloudwatch_event_target" "this" {
  for_each = { for sub in local.domain_subscriptions : "${sub.name}-${sub.domain}" => sub }

  event_bus_name = aws_cloudwatch_event_bus.this.arn
  role_arn       = aws_iam_role.domain_bus_invoke_local_event_buses.arn
  rule           = "${each.value.name}-${each.value.domain}"
  arn            = each.value.target_bus_arn

  depends_on = [aws_cloudwatch_event_rule.this]

}

# create new relic policy for domain bus
resource "newrelic_alert_policy" "domain_subscription_policy" {
  name = "[${upper(var.env)}] EventHub - ${var.domain_bus_name} Domain Subscriber Policy"
}

# create new relic condition for domain bus rules
resource "newrelic_nrql_alert_condition" "domain_subscription_failed_invocations" {
  for_each = { for sub in local.domain_subscriptions : "${sub.name}-${sub.domain}" => sub }

  name                           = "[${upper(var.env)}] EventHub - ${var.domain_bus_name}: Too many failed invocations for ${aws_cloudwatch_event_rule.this[each.key].name}"
  policy_id                      = newrelic_alert_policy.domain_subscription_policy.id
  expiration_duration            = 21600
  open_violation_on_expiration   = false
  close_violations_on_expiration = true

  nrql {
    query = "SELECT sum(`aws.events.FailedInvocations`) FROM Metric WHERE `collector.name` = 'cloudwatch-metric-streams' AND `aws.accountId` = '${data.aws_caller_identity.current.account_id}' AND `aws.Namespace` = 'AWS/Events' AND aws.events.RuleName = '${aws_cloudwatch_event_rule.this[each.key].name}'"
  }

  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 600
    threshold_occurrences = "AT_LEAST_ONCE"
  }
}

resource "newrelic_workflow" "domain_subscription_workflow" {
  name                  = "[${upper(var.env)}] EventHub - ${var.domain_bus_name} Domain Subscriber Workflow"
  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

  issues_filter {
    name = newrelic_alert_policy.domain_subscription_policy.name
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values    = [newrelic_alert_policy.domain_subscription_policy.id]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.ops_webhook.id
  }
}

