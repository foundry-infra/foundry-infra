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

resource "helm_release" "foundry" {
  name = var.foundry_server_name
  chart = "./foundry-vtt-helm"
  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      issuer_name = var.issuer_name,
      service_account_name = local.service_account_name,
      workaround_subdomain_name = var.workaround_subdomain_name,
      vault_role_name = var.role_name
      claim_name = var.claim_name
      hostname = var.foundry_hostname
      foundry_server_name = var.foundry_server_name
      foundry_server_tls_secret_name = var.foundry_server_tls_secret_name
    }),
    templatefile(var.values_yaml_path, {
      issuer_name = var.issuer_name,
      service_account_name = local.service_account_name,
      workaround_subdomain_name = var.workaround_subdomain_name,
      vault_role_name = var.role_name
      claim_name = var.claim_name
      hostname = var.foundry_hostname
      foundry_server_name = var.foundry_server_name
      foundry_server_tls_secret_name = var.foundry_server_tls_secret_name
    })
  ]
}
