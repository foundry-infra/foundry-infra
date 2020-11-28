terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "ingress" {
  yaml_body = templatefile("${path.module}/templates/ingress.yaml", {
    issuer_name = var.issuer_name
    namespace = var.k8s_namespace
    vault_subdomain_name = var.vault_subdomain_name
    vault_backend_service_name = var.vault_backend_service_name
    vault_backend_service_port = var.vault_backend_service_port
  })
}
