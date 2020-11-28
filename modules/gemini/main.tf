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

resource "helm_release" "gemini" {
  name       = "gemini"
  repository = "https://charts.fairwinds.com/stable/"
  chart      = "gemini"
  namespace  = var.k8s_namespace
}

