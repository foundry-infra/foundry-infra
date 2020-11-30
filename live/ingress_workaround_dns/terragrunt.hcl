terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/ingress_workaround_dns?ref=v0.0.7-rc2"
}

include {
  path = find_in_parent_folders()
}

dependency "k8s" {
  config_path = "../k8s"
}

dependency "ingress" {
  config_path = "../ingress"
  mock_outputs = {
    lb_ip = "1.1.1.1"
  }
}

inputs = {
  workaround_domain_hostname = "goldengulp.com"
  loadbalancer_ip = dependency.ingress.outputs.lb_ip
  platform_provider = {
    k8s_namespace = "platform"
    k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
    k8s_token = dependency.k8s.outputs.k8s_token
    k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
    digitalocean_api_token = "${get_env("TF_VAR_DO_TOKEN", "")}"
  }
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
