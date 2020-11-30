terraform {
  required_providers {
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

data "vault_auth_backend" "kubernetes" {
  path = "kubernetes/"
}

resource "vault_policy" "policy" {
  name = local.service_account_name

  policy = <<EOT
path "foundry/data/${local.service_account_name}/config" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "role" {
  backend                          = data.vault_auth_backend.kubernetes.path
  role_name                        = local.service_account_name
  bound_service_account_names      = [local.service_account_name]
  bound_service_account_namespaces = [local.service_account_name]
  token_ttl                        = 3600
  token_policies                   = [local.service_account_name]
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.foundry_server_name
  }
}

