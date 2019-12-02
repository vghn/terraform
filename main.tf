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

provider "cloudflare" {
  version = "~> 2.0"
  email   = data.aws_ssm_parameter.cf_email.value
  api_key = data.aws_ssm_parameter.cf_api_key.value
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

module "ursa" {
  source = "./ursa"

  email = data.aws_ssm_parameter.email.value

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

  email                      = data.aws_ssm_parameter.email.value
  terraform_trusted_user_arn = module.ursa.terraform_user_arn
  cloudflare_email           = data.aws_ssm_parameter.cf_email.value
  cloudflare_api_key         = data.aws_ssm_parameter.cf_api_key.value
  cloudflare_zone_id         = "9cc5582c31c278418dd6d1420083772c"

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

  email                      = data.aws_ssm_parameter.email.value
  terraform_trusted_user_arn = module.ursa.terraform_user_arn
  cloudflare_email           = data.aws_ssm_parameter.cf_email.value
  cloudflare_api_key         = data.aws_ssm_parameter.cf_api_key.value
  cloudflare_zone_id         = "9cc5582c31c278418dd6d1420083772c"

  common_tags = merge(
    local.common_tags,
    {
      "Account" = "hydra"
    },
  )
}
