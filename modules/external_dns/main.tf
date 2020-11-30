terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "external_dns" {
  name      = "external-dns"
  repository = "https://charts.helm.sh/stable"
  chart     = "external-dns"
  namespace = var.platform_provider.k8s_namespace

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      digitalocean_api_token = var.platform_provider.digitalocean_api_token,
    })
  ]
}
