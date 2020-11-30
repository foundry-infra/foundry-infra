terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/foundry?ref=v0.0.7"
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

dependency "ns" {
  config_path = "../ns"
  mock_outputs = {
    namespace = "platform-mock"
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

dependency "pvc" {
  config_path = "../goldengulp_pvc"
  mock_outputs = {
    claim_name = "goldengulp_mock"
  }
}

dependency "ingress_workaround_dns" {
  config_path = "../ingress_workaround_dns"
}

dependency "tls" {
  config_path = "../goldengulp_tls"
  mock_outputs = {
    secret_name = "goldengulp_mock"
  }
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
  foundry_hostname = "foundry2.goldengulp.com"
  workaround_subdomain_name = dependency.ingress_workaround_dns.outputs.workaround_subdomain_name
  issuer_name = "letsencrypt-staging"
  values_yaml_path = "${get_terragrunt_dir()}/values.yaml"
  claim_name = dependency.pvc.outputs.claim_name
  namespace = dependency.policies.outputs.namespace
  role_name = dependency.policies.outputs.role_name
  foundry_server_tls_secret_name = dependency.tls.outputs.secret_name
}

generate "helm_provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "helm" {
  kubernetes {
    load_config_file = false
    host             = var.platform_provider.k8s_endpoint
    token            = var.platform_provider.k8s_token
    cluster_ca_certificate = var.platform_provider.k8s_cluster_ca_certificate_b64d
  }
}
EOF
}
