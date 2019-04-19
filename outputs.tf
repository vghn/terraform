output "outputs" {
  sensitive = true

  value = <<EOF

Terraform
  User: (${module.ursa.terraform_user_arn}): ${module.ursa.terraform_access_key_id} - ${module.ursa.terraform_secret_access_key}
  Roles:
      Ursa: ${module.ursa.terraform_role_arn}
      Lyra: ${module.lyra.terraform_role_arn}
      Hydra: ${module.hydra.terraform_role_arn}
      Orion: ${module.orion.terraform_role_arn}
      MEC7: ${module.mec7.terraform_role_arn}

VBot
  User: (${module.ursa.vbot_user_arn}): ${module.ursa.vbot_access_key_id} - ${module.ursa.vbot_secret_access_key}
  Role: ${module.ursa.vbot_role_arn}

Prometheus instance: ${module.lyra.prometheus_instance_public_dns} (${module.lyra.prometheus_instance_public_ip})

Vault instance: ${module.hydra.vault_instance_public_dns} (${module.hydra.vault_instance_public_ip})

Notification topic arns:
  - Ursa: ${module.ursa.notifications_topic_arn}
  - Hydra: ${module.hydra.notifications_topic_arn}
  - Orion: ${module.orion.notifications_topic_arn}
  - MEC7: ${module.mec7.notifications_topic_arn}

EOF
}
