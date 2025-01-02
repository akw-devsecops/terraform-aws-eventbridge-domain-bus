<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_bus.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) | resource |
| [aws_cloudwatch_event_bus_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus_policy) | resource |
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.local_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.domain_bus_invoke_local_event_buses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.publish](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_bus_name"></a> [domain\_bus\_name](#input\_domain\_bus\_name) | A unique name for your EventBridge Bus | `string` | n/a | yes |
| <a name="input_publishers"></a> [publishers](#input\_publishers) | All publishers (ARNs) which needs to publish events on central domain bus | <pre>map(object({<br>    iam_role_arn = string<br>  }))</pre> | `{}` | no |
| <a name="input_subscribers"></a> [subscribers](#input\_subscribers) | Event subscriptions | <pre>map(object({<br>    consumer_service = string<br>    target_bus_arn   = string<br>    event_subscriptions = map(object({<br>      event_type    = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eventbridge_domain_bus_arn"></a> [eventbridge\_domain\_bus\_arn](#output\_eventbridge\_domain\_bus\_arn) | Domain Event Bridge Bus ARN |
| <a name="output_eventbridge_domain_bus_name"></a> [eventbridge\_domain\_bus\_name](#output\_eventbridge\_domain\_bus\_name) | Domain EventBridge Bus name |
| <a name="output_eventbridge_iam_role_arn"></a> [eventbridge\_iam\_role\_arn](#output\_eventbridge\_iam\_role\_arn) | IAM Role ARN for the local bus to forward events to sqs |
| <a name="output_eventbridge_iam_role_name"></a> [eventbridge\_iam\_role\_name](#output\_eventbridge\_iam\_role\_name) | IAM Role name for the domain bus to forward events to local bus |
| <a name="output_eventbridge_rule_arns"></a> [eventbridge\_rule\_arns](#output\_eventbridge\_rule\_arns) | Event Bridge Rule ARNs |
| <a name="output_eventbridge_rule_ids"></a> [eventbridge\_rule\_ids](#output\_eventbridge\_rule\_ids) | Event Bridge Rule IDs |
<!-- END_TF_DOCS -->