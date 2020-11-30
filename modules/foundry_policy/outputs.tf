output "namespace" {
  value = kubernetes_namespace.ns.metadata.0.name
}

output "service_account_name" {
  value = local.service_account_name
}

output "policy_name" {
  value = vault_policy.policy.name
}

output "role_name" {
  value = vault_kubernetes_auth_backend_role.role.role_name
}
