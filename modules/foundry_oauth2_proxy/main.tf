terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

locals {
  service_account_name = var.foundry_server_name
}

resource "helm_release" "oauth2_proxy" {
  name = "${var.foundry_server_name}-oauth2-proxy"
  chart = "oauth2-proxy"
  repository = "https://charts.helm.sh/stable"
  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      foundry_server_name =var.foundry_server_name
      service_account_name = local.service_account_name,
      workaround_subdomain_name = var.workaround_subdomain_name,
      vault_role_name = var.role_name
      cluster_issuer_ref_name = var.cluster_issuer_ref_name
      foundry_server_tls_secret_name = var.foundry_server_tls_secret_name
      foundry_hostname = var.foundry_hostname
    }),
    templatefile(var.values_yaml_path, {
      foundry_server_name =var.foundry_server_name
      service_account_name = local.service_account_name,
      workaround_subdomain_name = var.workaround_subdomain_name,
      vault_role_name = var.role_name
      cluster_issuer_ref_name = var.cluster_issuer_ref_name
      foundry_server_tls_secret_name = var.foundry_server_tls_secret_name
      foundry_hostname = var.foundry_hostname
    })
  ]
}
