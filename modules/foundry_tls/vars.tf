variable "platform_provider" {
  type = object({
    k8s_namespace = string
    k8s_endpoint = string
    k8s_token = string
    k8s_cluster_ca_certificate_b64d = string
    digitalocean_api_token = string
  })
}

variable "namespace" {}
variable "foundry_server_name" {}
