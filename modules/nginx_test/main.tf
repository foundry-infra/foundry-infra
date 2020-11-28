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

resource "helm_release" "nginx_test" {
  name      = "nginx-test"
  repository = "https://charts.bitnami.com/bitnami"
  chart     = "nginx"
  namespace = kubernetes_namespace.ns.metadata.0.name

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      issuer_name = var.issuer_name,
      hostname = var.hostname,
      workaround_subdomain_name = var.workaround_subdomain_name
    })
  ]
}

resource "kubernetes_namespace" "ns" {
  provider = kubernetes
  metadata {
    name = "nginx-test"
  }
}

