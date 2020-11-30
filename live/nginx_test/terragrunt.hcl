terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/nginx_test?ref=v0.0.7-rc1"
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

dependency "ingress_workaround_dns" {
  config_path = "../ingress_workaround_dns"
}

dependency "ns" {
  config_path = "../ns"
  mock_outputs = {
    namespace = "platform-mock"
  }
}

inputs = {
  k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
  k8s_token = dependency.k8s.outputs.k8s_token
  k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
  k8s_namespace = "nginx-test"
  digitalocean_api_token = "${get_env("TF_VAR_DO_TOKEN", "")}"
  hostname = "nginx.goldengulp.com"
  workaround_subdomain_name = dependency.ingress_workaround_dns.outputs.workaround_subdomain_name
  issuer_name = "letsencrypt-staging"
  login_username = "xmclark"
}
