terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/metrics_server?ref=v0.0.12"
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

inputs = {
  platform_provider = {
    k8s_namespace = "kube-system"
    k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
    k8s_token = dependency.k8s.outputs.k8s_token
    k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
  }
}

generate "helm_provider" {
  path      = "provider.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "helm" {
  kubernetes {
    host             = var.platform_provider.k8s_endpoint
    token            = var.platform_provider.k8s_token
    cluster_ca_certificate = var.platform_provider.k8s_cluster_ca_certificate_b64d
  }
}
EOF
}