terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/vpc?ref=v0.0.8-rc1"
}

include {
  path = find_in_parent_folders()
}

locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  vpc_name = "ruste-dev"
  vpc_region = local.region_vars.locals.do_region
}

generate "do_provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "digitalocean" {
  token = "${get_env("TF_VAR_DO_TOKEN", "")}"
  spaces_access_id = "${get_env("TF_VAR_DO_SPACES_KEY", "")}"
  spaces_secret_key = "${get_env("TF_VAR_DO_SPACES_SECRET", "")}"
}
EOF
}
