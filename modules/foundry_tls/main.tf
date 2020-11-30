terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.7.0"
    }
  }
}

resource "kubernetes_secret" "secret"  {
  metadata {
    name = "${var.foundry_server_name}-tls"
    namespace = var.namespace
  }
  lifecycle {
    ignore_changes = [data, metadata.0.annotations]
  }
}

