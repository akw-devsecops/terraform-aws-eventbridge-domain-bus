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
}
