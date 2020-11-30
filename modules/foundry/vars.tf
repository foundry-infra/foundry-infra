variable "platform_provider" {
  type = object({
    k8s_namespace = string
    k8s_endpoint = string
    k8s_token = string
    k8s_cluster_ca_certificate_b64d = string
    digitalocean_api_token = string
  })
}

variable "foundry_server_name" {}
variable "foundry_hostname" {}
variable "workaround_subdomain_name" {}
variable "issuer_name" {}
variable "values_yaml_path" {}
variable "pat" {}
variable "claim_name" {}
variable "namespace" {}
variable "role_name" {}
