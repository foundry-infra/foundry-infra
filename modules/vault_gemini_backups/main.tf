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

provider "kubernetes" {
  load_config_file = false
  host             = var.k8s_endpoint
  token            = var.k8s_token
  cluster_ca_certificate = var.k8s_cluster_ca_certificate_b64d
}

provider "kubectl" {
  host = var.k8s_endpoint
  token            = var.k8s_token
  cluster_ca_certificate = var.k8s_cluster_ca_certificate_b64d
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host             = var.k8s_endpoint
    token            = var.k8s_token
    cluster_ca_certificate = var.k8s_cluster_ca_certificate_b64d
  }
}

resource "kubectl_manifest" "config" {
  yaml_body = templatefile("${path.module}/templates/config.yaml", {
    vault_claim_name = var.vault_claim_name
    namespace = var.k8s_namespace
  })
}
