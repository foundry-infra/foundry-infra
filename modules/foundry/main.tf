terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.2.0"
    }
    vault = {
      source = "hashicorp/vault"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.7.0"
    }
  }
}

locals {
  service_account_name = var.foundry_server_name
}

resource "vault_policy" "policy" {
  name = local.service_account_name

  policy = <<EOT
path "foundry/data/${local.service_account_name}/config" {
  capabilities = ["read"]
}
EOT
}

data "vault_auth_backend" "kubernetes" {
  path = "kubernetes/"
}

resource "vault_kubernetes_auth_backend_role" "role" {
  backend                          = data.vault_auth_backend.kubernetes.path
  role_name                        = local.service_account_name
  bound_service_account_names      = [local.service_account_name]
  bound_service_account_namespaces = [local.service_account_name]
  token_ttl                        = 3600
  token_policies                   = [local.service_account_name]
}

resource "helm_release" "foundry" {
  name = var.foundry_server_name
  chart = "./foundry-vtt-helm"
  namespace = kubernetes_namespace.ns.metadata.0.name

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      issuer_name = var.issuer_name,
      service_account_name = local.service_account_name,
      workaround_subdomain_name = var.workaround_subdomain_name,
      vault_role_name = vault_kubernetes_auth_backend_role.role.role_name,
      hostname = var.foundry_hostname
      foundry_server_name = var.foundry_server_name
      claim_name = var.claim_name
    }),
    templatefile(var.values_yaml_path, {
      issuer_name = var.issuer_name,
      service_account_name = local.service_account_name,
      workaround_subdomain_name = var.workaround_subdomain_name,
      vault_role_name = vault_kubernetes_auth_backend_role.role.role_name,
      hostname = var.foundry_hostname
      foundry_server_name = var.foundry_server_name
    })
  ]
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.foundry_server_name
  }
}

