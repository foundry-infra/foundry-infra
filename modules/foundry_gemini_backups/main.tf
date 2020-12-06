terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "config" {
  yaml_body = templatefile("${path.module}/templates/config.yaml", {
    pvc_name = var.pvc_name
    namespace = var.namespace
    name = var.name
  })
}
