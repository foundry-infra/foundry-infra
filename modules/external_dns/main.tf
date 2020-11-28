terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
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

locals {
  f = templatefile("${path.module}/templates/values.tmpl", {
    digitalocean_api_token = var.digitalocean_api_token,
  })
}

resource "helm_release" "external_dns" {
  name      = "external-dns"
  repository = "https://charts.helm.sh/stable"
  chart     = "external-dns"
  namespace = var.k8s_namespace

  values = [
    local.f
  ]
}
