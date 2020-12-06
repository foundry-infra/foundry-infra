terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/foundry_gemini_backups?ref=v0.0.10-rc1"
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

dependency "gemini" {
  config_path = "../gemini"
  mock_outputs = {}
}

dependency "pvc" {
  config_path = "../goldengulp_pvc"
  mock_outputs = {
    claim_name = "goldengulp-mock"
  }
}

dependency "policies" {
  config_path = "../goldengulp_policies"
  mock_outputs = {
    namespace = "goldengulp_mock"
    service_account_name = "goldengulp_mock"
    policy_name = "goldengulp_mock"
    role_name = "goldengulp_mock"
  }
}

inputs = {
  platform_provider = {
    k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
    k8s_token = dependency.k8s.outputs.k8s_token
    k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
  }
  name = "goldengulp"
  namespace = dependency.policies.outputs.namespace
  claim_name = dependency.pvc.outputs.claim_name
}

generate "kubectl_provider" {
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
