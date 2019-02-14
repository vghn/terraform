output "outputs" {
  sensitive = true

  value = <<EOF

IAM Users:
  - mini (${module.ursa.mini_user_arn}): ${module.ursa.mini_access_key_id} - ${module.ursa.mini_secret_access_key}
  - rhea (${module.ursa.rhea_user_arn}): ${module.ursa.rhea_access_key_id} - ${module.ursa.rhea_secret_access_key}
  - terraform (${module.ursa.terraform_user_arn}): ${module.ursa.terraform_access_key_id} - ${module.ursa.terraform_secret_access_key}
  - vbot (${module.ursa.vbot_user_arn}): ${module.ursa.vbot_access_key_id} - ${module.ursa.vbot_secret_access_key}

IAM Roles:
  - Prometheus Role ARN for MEC7: ${module.mec7.prometheus_role_arn}
  - VBot Role ARN for Ursa: ${module.ursa.vbot_role_arn}
  - Terraform Role ARN for Ursa: ${module.ursa.terraform_role_arn}
  - Terraform Role ARN for Orion: ${module.orion.terraform_role_arn}
  - Terraform Role ARN for MEC7: ${module.mec7.terraform_role_arn}

Notification topic arns:
  - Ursa: ${module.ursa.notifications_topic_arn}
  - Orion: ${module.orion.notifications_topic_arn}
  - MEC7: ${module.mec7.notifications_topic_arn}

The address of the PuppetDB RDS instance ${module.orion.puppetdb_instance_address}

Prometheus instance: ${module.orion.prometheus_instance_public_dns} (${module.orion.prometheus_instance_public_ip})

EOF
}
