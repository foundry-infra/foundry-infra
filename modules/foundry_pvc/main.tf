terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  metadata {
    name = var.claim_name
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.requests_storage_size
      }
    }
    storage_class_name = "do-block-storage"
  }
}
