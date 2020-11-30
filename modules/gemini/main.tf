terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "gemini" {
  name       = "gemini"
  repository = "https://charts.fairwinds.com/stable/"
  chart      = "gemini"
  namespace  = var.platform_provider.k8s_namespace
}

