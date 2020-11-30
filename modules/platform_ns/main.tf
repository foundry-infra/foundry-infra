terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

// The platform namespace will be the main namespace where all application platform components get deployed
resource "kubernetes_namespace" "platform_ns" {
  metadata {
    name = var.namespace
  }
}
