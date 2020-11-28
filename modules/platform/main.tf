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
  source = "../vpc"
  vpc_name = var.vpc_name
  vpc_region = var.vpc_region
}

module "cluster" {
  source = "../k8s"
  cluster_name = var.cluster_name
  vpc_uuid = module.vpc.vpc_uuid
  vpc_region = var.vpc_region
  k8s_version = var.k8s_version
}

provider "kubernetes" {
  load_config_file = false
  cluster_ca_certificate = module.cluster.k8s_cluster_ca_certificate_b64d
  host = module.cluster.k8s_endpoint
  token = module.cluster.k8s_token
}

// The platform namespace will be the main namespace where all application platform components get deployed
resource "kubernetes_namespace" "platform_ns" {
  provider = kubernetes
  metadata {
    name = "platform"
  }
  depends_on = [module.cluster]
}

module "gemini" {
  source = "../gemini"
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
}

module "ingress" {
  source = "../ingress"
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
}

module "ingress_workaround_dns" {
  source = "../ingress_workaround_dns"
  loadbalancer_ip = module.ingress.lb_ip
  workaround_domain_hostname = "goldengulp.com"
}

module "external_dns" {
  source = "../external_dns"
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
  digitalocean_api_token = var.digitalocean_api_token
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
}

module "cert_manager" {
  source = "../cert_manager"
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
  digitalocean_api_token = var.digitalocean_api_token
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
}

module "cert_manager_issuers" {
  source = "../cert_manager_cluster_issuer"
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
  email = "mackenzie.a.z.c@gmail.com"
}

// up to here, nothing depends on vault

module "vault_ui_tls" {
  source = "../vault_ui_tls"
  cluster_issuer_ref_name = var.vault_issuer_name
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
  root_domain_name = "goldengulp.com"
  subdomain_name = "vault.goldengulp.com"
}

module "vault" {
  source = "../vault"
  domain = var.vault_domain
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
  workaround_subdomain_name = module.ingress_workaround_dns.workaround_subdomain_name
  tls_secret_name = module.vault_ui_tls.secret_name
}

module "vault_gemini_backups" {
  source = "../vault_gemini_backups"
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_token = module.cluster.k8s_token
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
  vault_claim_name = kubernetes_namespace.platform_ns.metadata.0.name
}

module "vault_ui_ingress" {
  source = "../vault_ui_ingress"
  issuer_name = var.vault_issuer_name
  k8s_cluster_ca_certificate_b64d = module.cluster.k8s_cluster_ca_certificate_b64d
  k8s_endpoint = module.cluster.k8s_endpoint
  k8s_namespace = kubernetes_namespace.platform_ns.metadata.0.name
  k8s_token = module.cluster.k8s_token
  vault_backend_service_name = module.vault.vault-ui-service-name
  vault_backend_service_port = module.vault.vault-ui-service-port
  vault_subdomain_name = var.vault_subdomain_name
}
