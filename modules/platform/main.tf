terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.2.0"
    }
  }
}

data "digitalocean_project" "project" {
  name = var.project_name
}

module "vpc" {
  source = "git@github.com:xmclark/foundry-infra.git//modules/vpc?ref=v0.0.1"
  vpc_name = var.vpc_name
  vpc_region = var.vpc_region
}

module "cluster" {
  source = "git@github.com:xmclark/foundry-infra.git//modules/k8s?ref=v0.0.1"
  cluster_name = var.cluster_name
  vpc_uuid = module.vpc.vpc_uuid
  vpc_region = var.vpc_region
  k8s_version = var.k8s_version
}

module "vault" {
  source = "git@github.com:xmclark/foundry-infra.git//modules/vault?ref=dev"
  domain = var.vault_domain
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
}
