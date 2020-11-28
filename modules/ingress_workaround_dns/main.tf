terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.2.0"
    }
  }
}

data "digitalocean_domain" "workaround_domain" {
  name = var.workaround_domain_hostname
}

resource "digitalocean_record" "workaround" {
  domain = data.digitalocean_domain.workaround_domain.name
  type   = "A"
  name   = "workaround"
  value  = var.loadbalancer_ip
}

