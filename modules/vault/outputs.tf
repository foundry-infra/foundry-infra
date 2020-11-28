output "vault-ui-service-name" {
  value = "${helm_release.vault_primary.name}-ui"
}

output "vault-ui-service-port" {
  value = 8200
}
