terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.2.0"
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

resource "helm_release" "oauth2_proxy" {
  name      = "oauth2-proxy"
  repository = "https://charts.helm.sh/stable"
  chart     = "oauth2-proxy"
  namespace = var.k8s_namespace

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
    })
  ]
}

resource "kubernetes_namespace" "ns" {
  provider = kubernetes
  metadata {
    name = "nginx-test"
  }
}

