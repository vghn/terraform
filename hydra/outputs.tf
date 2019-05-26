# Notifications
output "notifications_topic_arn" {
  description = "Notifications topic ARN"
  value       = module.notifications.topic_arn
}

# Terraform
output "terraform_role_arn" {
  description = "Terraform role ARN"
  value       = aws_iam_role.terraform.arn
}

# Vault instance
output "vault_instance_public_ip" {
  description = "Vault instance IP address"
  value       = aws_eip.vault.public_ip
}

output "vault_instance_public_dns" {
  description = "Vault instance DNS address"
  value       = data.null_data_source.vault.outputs["public_dns"]
}

