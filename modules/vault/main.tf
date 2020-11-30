terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "vault_primary" {
  name       = "vault-primary"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "vault"
  namespace  = var.platform_provider.k8s_namespace

  values = [
    templatefile("${path.module}/templates/values.tmpl", {
      replicas               = var.initial_node_count,
      enable_vault_ui        = var.enable_vault_ui,
      vault_service_type     = var.vault_service_type,
      tls_disable            = var.vault_tls_disable,
      vault_image_repository = var.vault_image_repository,
      vault_image_tag        = var.vault_image_tag
      vault_enable_audit     = var.vault_enable_audit
      agent_init_first       = var.agent_init_first
      dev_mode               = var.dev_mode
      workaround_subdomain_name = var.workaround_subdomain_name
      tls_secret_name = var.tls_secret_name
      issuer_name = var.issuer_name
      vault_subdomain_name = var.vault_subdomain_name
    })
  ]
}
