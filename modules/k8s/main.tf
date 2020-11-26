terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.2.0"
    }
  }
}

resource "digitalocean_kubernetes_cluster" "main" {
  name = var.cluster_name
  region = var.vpc_region
  vpc_uuid = var.vpc_uuid
  version = var.k8s_version
  node_pool {
    size = "s-2vcpu-4gb"
    name = "${var.cluster_name}-default-pool-01"
    node_count = 3
  }
}
