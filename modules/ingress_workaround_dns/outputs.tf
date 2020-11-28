output "workaround_subdomain_name" {
  value = "${digitalocean_record.workaround.name}.${digitalocean_record.workaround.domain}"
}
