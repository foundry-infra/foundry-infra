terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart     = "cert-manager"
  namespace = var.platform_provider.k8s_namespace

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      digitalocean_api_token = var.platform_provider.digitalocean_api_token,
    })
  ]
}
