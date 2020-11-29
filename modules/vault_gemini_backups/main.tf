terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "kubectl_manifest" "config" {
  yaml_body = templatefile("${path.module}/templates/config.yaml", {
    vault_claim_name = var.vault_claim_name
    namespace = var.k8s_namespace
  })
}
