# This file shows an example how to use and setup the terraform-aws-eventbridge-domain-bus module

# An event bus needs rules and targets. Rules check whether the event matches the pattern that is defined in the rule.
# If there is a match, the event is forwarded to the target (in this case: another (local) bus in another account).

module "xxx-domain" {
  source = ""

  # domain bus name
  domain_bus_name = "xxx-domain"

  # this is the basic setup of the variable domain_subscribers
  # in this variable is defined: which subscriber wants to receive which events of a specific source

  domain_subscribers_empty_example = {
    xy-domain_software_data = { # Domain-Name: "xy" wants to subscribe events from "Software Data"
      consumer_service = ""     # this is the name of the service which is subscribing the events
      target_bus_arn   = ""     # ARN of the target bus (bus in "xy" account which is to receive the events)
      event_subscriptions = {
        new_software_release_available_v1 = { # this name + domain-name is used for creating the rule
          event_type    = ""                  # this will be used as the pattern for the rule
          event_version = ""                  # this is the version of the event
        },
        new_software_release_available_v2 = {
          event_type    = ""
        }
      }
    },
    # for a new subscriber such add a new block:
    xz-domain_software_data = { # Another domain-name: "xz" wants to subscribe events from "Software Data"
      consumer_service = ""
      target_bus_arn   = "" # ARN of the target bus (bus in "xz" account)
      event_subscriptions = {
        new_iot_event_available_v1 = { # this name + domain-name is used for creating the rule
          event_type    = ""
          event_version = ""
        },
        new_iot_machine_registered_v1 = {
          event_type    = ""
        }
      }
    },

    # for each subscriber such a block like above is required
  }

  # define which publisher is allowed to publish on this domain bus
  publishers = {
    software_data = {
      publisher_arn = "arn:aws:iam::123456789012:role/eventbridge-software-data-publisher"
    }
  }
}
