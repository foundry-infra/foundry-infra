module "cluster" {
  source = "github.com:xmclark/foundry-infra.git//modules/k8s"
  cluster_name = var.k8s_cluster_name
  vpc_uuid = var.vpc_uuid
}

provider "helm" {
  kubernetes {
    host     = "https://104.196.242.174"
    username = ""
    password = ""

    client_certificate     = file("~/.kube/client-cert.pem")
    client_key             = file("~/.kube/client-key.pem")
    cluster_ca_certificate = file("~/.kube/cluster-ca-cert.pem")
  }
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "vault"
  }
}

resource "helm_release" "release" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.8.0"
}
