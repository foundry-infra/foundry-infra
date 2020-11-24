variable "cluster_name" {
  type = string
  description = "Name of the VPC"
}

variable "vpc_region" {
  type = string
  description = "DO Region of the VPC"
  default = "sfo2"
}

variable "vpc_uuid" {
  type = string
  description = "DO VPC UUID"
}
