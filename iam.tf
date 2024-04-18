data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# role for event service
resource "aws_iam_role" "domain_bus_invoke_local_event_buses" {
  name               = "${var.domain_bus_name}-domain-bus-invoke-local-event-buses"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "publish" {
  statement {
    effect    = "Allow"
    actions   = ["events:PutEvents"]
    resources = local.all_targets
  }
}

resource "aws_iam_policy" "local_bus" {
  name   = "${var.domain_bus_name}_domain_bus_invoke_local_buses"
  policy = data.aws_iam_policy_document.publish.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.domain_bus_invoke_local_event_buses.name
  policy_arn = aws_iam_policy.local_bus.arn
}
