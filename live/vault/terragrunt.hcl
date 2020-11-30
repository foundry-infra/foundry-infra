terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/vault?ref=v0.0.5-rc6"
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

dependency "vault_ui_tls" {
  config_path = "../vault_ui_tls"
}

dependency "ingress_workaround_dns" {
  config_path = "../ingress_workaround_dns"
}

inputs = {
  platform_provider = {
    k8s_namespace = "platform"
    k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
    k8s_token = dependency.k8s.outputs.k8s_token
    k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
    digitalocean_api_token = "${get_env("TF_VAR_DO_TOKEN", "")}"
  }
  workaround_subdomain_name = dependency.ingress_workaround_dns.outputs.workaround_subdomain_name
  issuer_name = "letsencrypt-staging"
  domain = "goldengulp.com"
  tls_secret_name = dependency.vault_ui_tls.outputs.secret_name
  vault_subdomain_name = "vault.goldengulp.com"
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
