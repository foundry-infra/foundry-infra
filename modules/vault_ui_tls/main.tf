terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.7.0"
    }
  }
}

resource "kubernetes_secret" "secret"  {
  metadata {
    name = "vault-ui-tls"
    namespace = var.k8s_namespace
  }
  lifecycle {
    ignore_changes = [data, metadata.0.annotations]
  }
}

resource "kubectl_manifest" "certificate" {
  yaml_body = templatefile("${path.module}/templates/certificate.yaml", {
    secret_name = kubernetes_secret.secret.metadata.0.name
    namespace = var.k8s_namespace
    cluster_issuer_ref_name = var.cluster_issuer_ref_name
    root_domain_name = var.root_domain_name
    subdomain_name = var.subdomain_name
  })
}

