
resource "newrelic_notification_destination" "ops_webhook" {
  name = "[${upper(var.env)}] EventHub - Ops WebHook"
  type = "WEBHOOK"

  property {
    key   = "url"
    value = var.ops_channel_webhook_url
  }
}

resource "newrelic_notification_channel" "ops_webhook" {
  name           = newrelic_notification_destination.ops_webhook.name
  type           = "WEBHOOK"
  destination_id = newrelic_notification_destination.ops_webhook.id
  product        = "IINT" // (Workflows)

  property {
    key = "payload"
    value = jsonencode({
      "cards" : [
        {
          "sections" : [
            {
              "widgets" : [
                {
                  "keyValue" : {
                    "topLabel" : "NEW RELIC INCIDENT {{issueId}}",
                    "content" : "{{#eq 'HIGH' priority}}WARNING{{else}}{{priority}}{{/eq}} - {{#if issueClosedAt}}closed{{else if issueAcknowledgedAt}}acknowledged{{else}}open{{/if}}",
                    "onClick" : {
                      "openLink" : {
                        "url" : "{{issuePageUrl}}"
                      }
                    }
                  }
                }
              ]
            },
            {
              "widgets" : [
                {
                  "keyValue" : {
                    "content" : "{{accumulations.conditionName.[0]}}",
                    "topLabel" : "Condition"
                  }
                },
                {
                  "keyValue" : {
                    "content" : "{{accumulations.policyName.[0]}}",
                    "topLabel" : "Policy"
                  }
                },
                {
                  "keyValue" : {
                    "content" : "{{issueTitle}}",
                    "topLabel" : "Details",
                    "contentMultiline" : "true"
                  }
                }
              ]
            },
            {
              "widgets" : [
                {
                  "buttons" : [
                    {
                      "textButton" : {
                        "text" : "View Incident",
                        "onClick" : {
                          "openLink" : {
                            "url" : "{{issuePageUrl}}"
                          }
                        }
                      }
                    },
                    {
                      "textButton" : {
                        "text" : "Ack Incident",
                        "onClick" : {
                          "openLink" : {
                            "url" : "{{issueAckUrl}}"
                          }
                        }
                      }
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    })
    label = "Payload Template"
  }
}