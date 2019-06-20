# Main
data "vault_generic_secret" "notifications" {
  path = "secrets/terraform/vgh/notifications"
}

# VBot
data "vault_generic_secret" "vbot_slack" {
  path = "secrets/terraform/vgh/vbot/slack"
}

# CloudFlare
data "vault_generic_secret" "cloudflare" {
  path = "secrets/terraform/vgh/cloudflare"
}

data "vault_generic_secret" "cosmin_cloudflare" {
  path = "secrets/terraform/cosmin/cloudflare"
}
