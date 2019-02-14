# Notifications
output "orion_notifications_topic_arn" {
  sensitive   = true
  description = "The Orion notifications topic ARN"
  value       = "${module.orion.notifications_topic_arn}"
}

output "ursa_notifications_topic_arn" {
  sensitive   = true
  description = "The Ursa notifications topic ARN"
  value       = "${module.ursa.notifications_topic_arn}"
}

output "mec7_notifications_topic_arn" {
  sensitive   = true
  description = "The MEC7 notifications topic ARN"
  value       = "${module.mec7.notifications_topic_arn}"
}

# PuppetDB
output "puppetdb_instance_address" {
  description = "The address of the PuppetDB RDS instance"
  value       = "${module.orion.puppetdb_instance_address}"
}

# Prometheus
output "prometheus_instance_public_ip" {
  description = "The IP address of the Prometheus instance"
  value       = "${module.orion.prometheus_instance_public_ip}"
}

output "prometheus_instance_public_dns" {
  description = "The DNS address of the Prometheus instance"
  value       = "${module.orion.prometheus_instance_public_dns}"
}

output "prometheus_mec7_role_arn" {
  sensitive   = true
  description = "Prometheus Role ARN for MEC7"
  value       = "${module.mec7.prometheus_role_arn}"
}

# Mini
output "mini_user_arn" {
  sensitive   = true
  description = "Mini user ARN"
  value       = "${module.ursa.mini_user_arn}"
}

output "mini_access_key_id" {
  sensitive   = true
  description = "Mini access key id"
  value       = "${module.ursa.mini_access_key_id}"
}

output "mini_secret_access_key" {
  sensitive   = true
  description = "Mini secret access key"
  value       = "${module.ursa.mini_secret_access_key}"
}

# Rhea
output "rhea_user_arn" {
  sensitive   = true
  description = "Rhea user ARN"
  value       = "${module.ursa.rhea_user_arn}"
}

output "rhea_access_key_id" {
  sensitive   = true
  description = "Rhea access key id"
  value       = "${module.ursa.rhea_access_key_id}"
}

output "rhea_secret_access_key" {
  sensitive   = true
  description = "Rhea secret access key"
  value       = "${module.ursa.rhea_secret_access_key}"
}

# Terraform
output "terraform_user_arn" {
  sensitive   = true
  description = "Terraform user ARN"
  value       = "${module.ursa.terraform_user_arn}"
}

output "terraform_access_key_id" {
  sensitive   = true
  description = "Terraform access key id"
  value       = "${module.ursa.terraform_access_key_id}"
}

output "terraform_secret_access_key" {
  sensitive   = true
  description = "Terraform secret access key"
  value       = "${module.ursa.terraform_secret_access_key}"
}

output "terraform_ursa_role_arn" {
  sensitive   = true
  description = "Terraform role ARN on Ursa"
  value       = "${module.ursa.terraform_role_arn}"
}

output "terraform_orion_role_arn" {
  sensitive   = true
  description = "Terraform role ARN on Orion"
  value       = "${module.orion.terraform_role_arn}"
}

output "terraform_mec7_role_arn" {
  sensitive   = true
  description = "Terraform role ARN on MEC7"
  value       = "${module.mec7.terraform_role_arn}"
}

# VBot
output "vbot_user_arn" {
  sensitive   = true
  description = "VBot user ARN"
  value       = "${module.ursa.vbot_user_arn}"
}

output "vbot_access_key_id" {
  sensitive   = true
  description = "VBot access key id"
  value       = "${module.ursa.vbot_access_key_id}"
}

output "vbot_secret_access_key" {
  sensitive   = true
  description = "VBot secret access key"
  value       = "${module.ursa.vbot_secret_access_key}"
}

output "vbot_role_arn" {
  sensitive   = true
  description = "VBot Role ARN for Ursa"
  value       = "${module.ursa.vbot_role_arn}"
}
