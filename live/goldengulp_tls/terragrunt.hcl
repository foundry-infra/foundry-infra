terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/foundry_tls?ref=v0.0.7-rc1"
}

include {
  path = find_in_parent_folders()
}

locals {
  platform_vars = read_terragrunt_config(find_in_parent_folders("platform.hcl"))
}

dependency "k8s" {
  config_path = "../k8s"
}

dependency "policies" {
  config_path = "../goldengulp_policies"
}

inputs = {
  platform_provider = {
    k8s_namespace = "platform"
    k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
    k8s_token = dependency.k8s.outputs.k8s_token
    k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
    digitalocean_api_token = "${get_env("TF_VAR_DO_TOKEN", "")}"
  }
  foundry_server_name = "goldengulp"
  namespace = dependency.policies.outputs.namespace
}

generate "k8s_provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "kubernetes" {
  load_config_file = false
  host             = var.platform_provider.k8s_endpoint
  token            = var.platform_provider.k8s_token
  cluster_ca_certificate = var.platform_provider.k8s_cluster_ca_certificate_b64d
}
EOF
}
