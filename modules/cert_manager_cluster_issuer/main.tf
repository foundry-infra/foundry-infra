terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "staging_issuer" {
  yaml_body = templatefile("${path.module}/templates/staging_issuer.yaml", {
    email = var.email
    namespace = var.platform_provider.k8s_namespace
  })
}

resource "kubectl_manifest" "prod_issuer" {
  yaml_body = templatefile("${path.module}/templates/prod_issuer.yaml", {
    email = var.email
    namespace = var.platform_provider.k8s_namespace
  })
}
