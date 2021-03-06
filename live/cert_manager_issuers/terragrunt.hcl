terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/cert_manager_cluster_issuer?ref=v0.0.9"
}

dependency "k8s" {
  config_path = "../k8s"
}

dependency "ns" {
  config_path = "../ns"
  mock_outputs = {
    namespace = "platform-mock"
  }
}

dependency "cert_manager" {
  config_path = "../cert_manager"
  mock_outputs = {}
}

include {
  path = find_in_parent_folders()
}

locals {
  platform_vars = read_terragrunt_config(find_in_parent_folders("platform.hcl"))
}

inputs = {
  email = local.platform_vars.locals.admin_email
  platform_provider = {
    k8s_namespace = "platform"
    k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
    k8s_token = dependency.k8s.outputs.k8s_token
    k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
    digitalocean_api_token = "${get_env("TF_VAR_DO_TOKEN", "")}"
  }
}

generate "k8s_provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "kubectl" {
  host             = var.platform_provider.k8s_endpoint
  token            = var.platform_provider.k8s_token
  cluster_ca_certificate = var.platform_provider.k8s_cluster_ca_certificate_b64d
}
EOF
}
