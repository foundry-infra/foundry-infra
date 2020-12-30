variable "k8s_version" {}

variable "cluster_name" {
  type = string
  description = "Name of the VPC"
}

variable "vpc_region" {
  type = string
  description = "DigitalOcean Region of the VPC"
  default = "sfo2"
}

variable "vpc_uuid" {
  type = string
  description = "DigitalOcean VPC UUID"
}

variable "node_count" {
  type = number
}
