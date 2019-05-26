data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

data "aws_iam_user" "vlad" {
  user_name = "vlad"
}

data "aws_iam_group" "Admins" {
  group_name = "Admins"
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
  account                 = "Ursa"

  common_tags = var.common_tags
}

module "cloudwatch_event_watcher" {
  source = "../modules/cloudwatch_event_watcher"

  common_tags = var.common_tags
}

module "cloudtrail" {
  source = "../modules/cloudtrail"

  common_tags = var.common_tags
}

