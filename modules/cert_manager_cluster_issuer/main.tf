terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  load_config_file = false
  host             = var.k8s_endpoint
  token            = var.k8s_token
  cluster_ca_certificate = var.k8s_cluster_ca_certificate_b64d
}

resource "kubectl_manifest" "staging_issuer" {
  yaml_body = templatefile("${path.module}/templates/staging_issuer.yaml", {
    email = var.email
    namespace = var.k8s_namespace
  })
}

resource "kubectl_manifest" "prod_issuer" {
  yaml_body = templatefile("${path.module}/templates/prod_issuer.yaml", {
    email = var.email
    namespace = var.k8s_namespace
  })
}
