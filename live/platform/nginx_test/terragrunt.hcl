terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/nginx_test?ref=v0.0.4"
}

dependency "platform" {
  config_path = "../instance"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  k8s_endpoint = dependency.platform.outputs.k8s_endpoint
  k8s_token = dependency.platform.outputs.k8s_token
  k8s_cluster_ca_certificate_b64d = dependency.platform.outputs.k8s_cluster_ca_certificate_b64d
  k8s_namespace = "nginx-test"
  digitalocean_api_token = "${get_env("TF_VAR_DO_TOKEN", "")}"
  hostname = "nginx.goldengulp.com"
  workaround_subdomain_name = dependency.platform.outputs.workaround_subdomain_name
  issuer_name = "letsencrypt-staging"
  login_username = "xmclark"
}
