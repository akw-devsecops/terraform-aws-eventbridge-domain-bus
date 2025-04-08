terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = ">= 3.0.0"
    }
  }
}
