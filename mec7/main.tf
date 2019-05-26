data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

data "aws_iam_role" "vlad" {
  name = "vlad"
}

module "notifications" {
  source = "../modules/notifications"
  email  = var.email

  common_tags = var.common_tags
}

module "billing" {
  source                  = "../modules/billing"
  notifications_topic_arn = module.notifications.topic_arn
  thresholds              = ["1", "2", "3", "4", "5"]
  account                 = "Orion"

  common_tags = var.common_tags
}

module "cloudwatch_event_watcher" {
  source      = "../modules/cloudwatch_event_watcher"
  common_tags = var.common_tags
}

module "cloudtrail" {
  source = "../modules/cloudtrail"

  common_tags = var.common_tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "MEC7"
  cidr = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  azs = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
    "us-west-2d",
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]

  tags = var.common_tags
}

