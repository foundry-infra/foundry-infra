terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/k8s?ref=v0.0.9-rc1"
}

include {
  path = find_in_parent_folders()
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  k8s_version = "1.19.3-do.2"
  cluster_name = "ruste-dev-apps"
  vpc_uuid = dependency.vpc.outputs.vpc_uuid
  vpc_region = local.env_vars.locals.do_region
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
