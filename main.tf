terraform {
  required_version = "~> 0.11"

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
  version = "~> 1.28"
}

provider "aws" {
  alias   = "ursa"
  profile = "ursa"
  region  = "us-east-1"
  version = "~> 1.28"
}

provider "aws" {
  alias   = "orion"
  profile = "orion"
  region  = "us-east-1"
  version = "~> 1.28"
}

provider "aws" {
  alias   = "mec7"
  profile = "mec7"
  region  = "us-west-2"
  version = "~> 1.28"
}

provider "cloudflare" {
  version = "~> 1.0"
  email   = "${data.aws_ssm_parameter.cf_email.value}"
  token   = "${data.aws_ssm_parameter.cf_token.value}"
}

provider "cloudflare" {
  alias   = "vgh"
  version = "~> 1.0"
  email   = "${data.aws_ssm_parameter.cf_email.value}"
  token   = "${data.aws_ssm_parameter.cf_token.value}"
}

provider "cloudflare" {
  alias   = "mec7"
  version = "~> 1.0"
  email   = "${data.aws_ssm_parameter.cosmin_cf_email.value}"
  token   = "${data.aws_ssm_parameter.cosmin_cf_token.value}"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
  version    = "~> 1.0"
}

provider "acme" {
  alias      = "production"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
  version    = "~> 1.0"
}

provider "acme" {
  alias      = "staging"
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  version    = "~> 1.0"
}

provider "random" {
  version = "~> 1.3"
}

provider "tls" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 1.0"
}

module "ursa" {
  source = "./ursa"

  providers = {
    aws        = "aws.ursa"
    cloudflare = "cloudflare.vgh"
  }

  email                       = "${data.aws_ssm_parameter.email.value}"
  prometheus_trusted_role_arn = "${module.orion.prometheus_role_arn}"
  prometheus_role_id          = "${module.orion.prometheus_role_id}"
  travis_orion_role_arn       = "${module.orion.travis_role_arn}"
  travis_mec7_role_arn        = "${module.mec7.travis_role_arn}"
  vbot_orion_role_arn         = "${module.orion.vbot_role_arn}"
  vbot_mec7_role_arn          = "${module.mec7.vbot_role_arn}"

  common_tags = "${merge(
    local.common_tags,
    map(
      "Account", "ursa"
    )
  )}"
}

module "orion" {
  source = "./orion"

  providers = {
    aws        = "aws.orion"
    cloudflare = "cloudflare.vgh"
  }

  email                   = "${data.aws_ssm_parameter.email.value}"
  puppet_secret           = "${data.aws_ssm_parameter.puppet_secret.value}"
  puppetdb_user           = "${data.aws_ssm_parameter.puppetdb_user.value}"
  puppetdb_pass           = "${data.aws_ssm_parameter.puppetdb_pass.value}"
  travis_trusted_user_arn = "${module.ursa.travis_user_arn}"
  vbot_trusted_user_arn   = "${module.ursa.vbot_user_arn}"

  common_tags = "${merge(
    local.common_tags,
    map(
      "Account", "ursa"
    )
  )}"
}

module "mec7" {
  source = "./mec7"

  providers = {
    aws        = "aws.mec7"
    cloudflare = "cloudflare.mec7"
  }

  email                       = "${data.aws_ssm_parameter.email.value}"
  prometheus_trusted_role_arn = "${module.orion.prometheus_role_arn}"
  travis_trusted_user_arn     = "${module.ursa.travis_user_arn}"
  vbot_trusted_user_arn       = "${module.ursa.vbot_user_arn}"

  common_tags = "${merge(
    local.common_tags,
    map(
      "Account", "mec7"
    )
  )}"
}
