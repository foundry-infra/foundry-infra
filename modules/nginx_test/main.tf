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
  }
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host             = var.k8s_endpoint
    token            = var.k8s_token
    cluster_ca_certificate = var.k8s_cluster_ca_certificate_b64d
  }
}

provider "kubernetes" {
  load_config_file = false
  host             = var.k8s_endpoint
  token            = var.k8s_token
  cluster_ca_certificate = var.k8s_cluster_ca_certificate_b64d
}

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

locals {
  service_account_name = "nginx-test"
}



resource "vault_policy" "policy" {
  name = local.service_account_name

  policy = <<EOT
path "foundry/data/${local.service_account_name}/test" {
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

resource "helm_release" "nginx_test" {
  name      = "nginx-test"
  repository     = "./chart"
  namespace = kubernetes_namespace.ns.metadata.0.name

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      issuer_name = var.issuer_name,
      hostname = var.hostname,
      workaround_subdomain_name = var.workaround_subdomain_name
    })
  ]
  chart = "nginx"
}

resource "kubernetes_namespace" "ns" {
  provider = kubernetes
  metadata {
    name = "nginx-test"
  }
}

