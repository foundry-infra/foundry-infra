terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/foundry_policy?ref=v0.0.6-rc2"
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

dependency "vault_kube" {
  config_path = "../vault_kube"
}

inputs = {
  platform_provider = {
    k8s_namespace = "platform"
    k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
    k8s_token = dependency.k8s.outputs.k8s_token
    k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
    digitalocean_api_token = "${get_env("TF_VAR_DO_TOKEN", "")}"
  }

  foundry_server_name = "frost-wind-terror"
  vault_auth_backend_path = dependency.vault_kube.outputs.vault_auth_backend_path
}

generate "helm_provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "vault" {
  address = "https://vault.goldengulp.com"
  skip_tls_verify = true
  auth_login {
    path = "auth/github/login"
    parameters = {
      token = var.pat
    }
  }
}
provider "kubernetes" {
  load_config_file = false
  host             = var.platform_provider.k8s_endpoint
  token            = var.platform_provider.k8s_token
  cluster_ca_certificate = var.platform_provider.k8s_cluster_ca_certificate_b64d
}
EOF
}
