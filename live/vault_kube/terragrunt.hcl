terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/vault_kube?ref=v0.0.8-rc3"
}

include {
  path = find_in_parent_folders()
}

locals {
  platform_vars = read_terragrunt_config(find_in_parent_folders("platform.hcl"))
}

dependency "vault" {
  config_path = "../vault"
}

generate "vault_provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "vault" {
  address = "https://secrets.of.goldengulp.com"
  skip_tls_verify = true
  auth_login {
    path = "auth/github/login"
    parameters = {
      token = var.pat
    }
  }
}
EOF
}
