locals {
  domain_subscriptions = flatten([
    for dk, dv in var.subscribers : [
      for ek, ev in dv.event_subscriptions : {
        domain           = dk
        target_bus_arn   = dv.target_bus_arn
        consumer_service = dv.consumer_service
        name             = ek
        description      = "${dk} domain bus subscription"
        event_pattern    = jsonencode({ "detail.type" : [ev.event_type] })
      }
    ]
  ])

  all_targets = try(flatten([
    for dk, dv in var.subscribers : [
      for ek, ev in dv.event_subscriptions : [
        dv.target_bus_arn
      ]
    ]
  ]), [])
}
