terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host             = var.k8s_endpoint
    token            = var.k8s_token
    cluster_ca_certificate = var.k8s_cluster_ca_certificate_b64d
  }
}

provider "kubernetes" {
  load_config_file = false
  host             = var.k8s_endpoint
  token            = var.k8s_token
  cluster_ca_certificate = var.k8s_cluster_ca_certificate_b64d
}

locals {
  f = templatefile("${path.module}/templates/values.tmpl", {
  })
}

resource "helm_release" "ingress_nginx" {
  name      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart     = "ingress-nginx"
  namespace = var.k8s_namespace

  values = [
    local.f
  ]
}

data "kubernetes_service" "lb" {
  metadata {
    name = "${helm_release.ingress_nginx.metadata.0.name}-controller"
    namespace = helm_release.ingress_nginx.metadata[0].namespace
  }
}

