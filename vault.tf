# Main
data "vault_generic_secret" "notifications" {
  path = "vgh/terraform/notifications"
}

# VBot
data "vault_generic_secret" "vbot_slack" {
  path = "vgh/terraform/vbot/slack"
}

# CloudFlare
data "vault_generic_secret" "cloudflare" {
  path = "vgh/terraform/cloudflare"
}
