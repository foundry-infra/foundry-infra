variable "k8s_namespace" {}

variable "k8s_endpoint" {}

variable "k8s_token" {}

variable "k8s_cluster_ca_certificate_b64d" {}

variable "enable_vault_ui" {
  description = "controls whether to enable the UI for Vault or not"
  default     = true
}

variable "vault_service_type" {
  description = "controls the type of Kubernetes service the Vault UI service gets"
  default     = "ClusterIP"
}

variable "vault_tls_disable" {
  description = "controls whether to disable tls for Vault or not"
  default     = false
}

variable "primary_hostname" {
  type        = string
  description = "hostname for self-signed certificate"
  default     = "vault-primary"
}

variable "domain" {
  type        = string
  description = "domain for self-signed certificate"
}

variable "initial_node_count" {
  description = "inital node count for kubernetes cluster"
  default     = "1"
}

variable "vault_image_repository" {
  type        = string
  description = "controls which repository to pull vault from"
  default     = "vault"
}

variable "vault_image_tag" {
  type        = string
  description = "controls which image to use"
  default     = "latest"
}

variable "vault_enable_audit" {
  description = "controls the enablement audit storage"
  default     = true
}

variable "agent_init_first" {
  default = "true"
}

variable "dev_mode" {
  default = "false"
}

variable "workaround_subdomain_name" {}

variable "tls_secret_name" {}

variable "issuer_name" {}

variable "vault_subdomain_name" {}
