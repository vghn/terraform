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
  source = "github.com/vghn/terraform-notifications"
  email  = var.email

  common_tags = var.common_tags
}

module "billing" {
  source                  = "github.com/vghn/terraform-billing"
  notifications_topic_arn = module.notifications.topic_arn
  thresholds              = ["1", "2", "3", "4", "5"]
  account                 = "Ursa"

  common_tags = var.common_tags
}

module "cloudwatch_event_watcher" {
  source = "github.com/vghn/terraform-cloudwatch_event_watcher"

  common_tags = var.common_tags
}

module "cloudtrail" {
  source = "github.com/vghn/terraform-cloudtrail"

  common_tags = var.common_tags
}
