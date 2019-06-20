terraform {
  backend "s3" {
    bucket         = "vgtf"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    acl            = "private"
    encrypt        = true
    dynamodb_table = "vgtf"
    profile        = "ursa"
  }
}

locals {
  common_tags = {
    Terraform = "true"
    Group     = "vgh"
    Project   = "vgh"
  }
}

provider "aws" {
  profile = "ursa"
  region  = "us-east-1"
  version = "~> 2.0"
}

provider "aws" {
  profile = "lyra"
  alias   = "lyra"
  region  = "us-east-1"
  version = "~> 2.0"
}

provider "aws" {
  profile = "hydra"
  alias   = "hydra"
  region  = "us-east-1"
  version = "~> 2.0"
}

provider "aws" {
  profile = "mec7"
  alias   = "mec7"
  region  = "us-west-2"
  version = "~> 2.0"
}

provider "cloudflare" {
  version = "~> 1.0"
  email   = data.vault_generic_secret.cloudflare.data["email"]
  token   = data.vault_generic_secret.cloudflare.data["token"]
}

provider "cloudflare" {
  alias   = "mec7"
  version = "~> 1.0"
  email   = data.vault_generic_secret.cosmin_cloudflare.data["email"]
  token   = data.vault_generic_secret.cosmin_cloudflare.data["token"]
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
  version    = "~> 1.0"
}

provider "acme" {
  alias      = "staging"
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  version    = "~> 1.0"
}

provider "archive" {
  version = "~> 1.0"
}

provider "random" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

provider "tls" {
  version = "~> 2.0"
}

provider "null" {
  version = "~> 2.0"
}

provider "vault" {
  version = "~> 2.0"
}

module "ursa" {
  source = "./ursa"

  email = data.vault_generic_secret.notifications.data["email"]

  common_tags = merge(
    local.common_tags,
    {
      "Account" = "ursa"
    },
  )
}

module "lyra" {
  source = "./lyra"

  providers = {
    aws = aws.lyra
  }

  email                      = data.vault_generic_secret.notifications.data["email"]
  terraform_trusted_user_arn = module.ursa.terraform_user_arn
  cf_email                   = data.vault_generic_secret.cloudflare.data["email"]
  cf_token                   = data.vault_generic_secret.cloudflare.data["token"]

  common_tags = merge(
    local.common_tags,
    {
      "Account" = "lyra"
    },
  )
}

module "hydra" {
  source = "./hydra"

  providers = {
    aws = aws.hydra
  }

  email                      = data.vault_generic_secret.notifications.data["email"]
  terraform_trusted_user_arn = module.ursa.terraform_user_arn
  cf_email                   = data.vault_generic_secret.cloudflare.data["email"]
  cf_token                   = data.vault_generic_secret.cloudflare.data["token"]

  common_tags = merge(
    local.common_tags,
    {
      "Account" = "hydra"
    },
  )
}

module "mec7" {
  source = "./mec7"

  providers = {
    aws        = aws.mec7
    cloudflare = cloudflare.mec7
  }

  email                      = data.vault_generic_secret.notifications.data["email"]
  terraform_trusted_user_arn = module.ursa.terraform_user_arn

  common_tags = merge(
    local.common_tags,
    {
      "Account" = "mec7"
    },
  )
}
