terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.regional]
    }
    time = {
      source = "hashicorp/time"
    }
  }
} 