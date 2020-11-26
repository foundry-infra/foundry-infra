terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.2.0"
    }
  }
}

resource "digitalocean_vpc" "main" {
  name = var.vpc_name
  region = var.vpc_region
}
