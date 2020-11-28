variable "project_name" {

}

variable "vpc_name" {
  type = string
  description = "Name of the VPC"
}

variable "vpc_region" {
  type = string
  description = "DO Region of the VPC"
  default = "sfo2"
}

variable "cluster_name" {
  type = string
  description = "Name of the VPC"
}

variable "vault_domain" {}

variable "k8s_version" {}

variable "digitalocean_api_token" {}

variable "vault_issuer_name" {}
variable "vault_subdomain_name" {}
