output "namespace" {
  value = kubernetes_namespace.ns.metadata.0.name
}

output "service_account_name" {
  value = local.service_account_name
}

output "policy_name" {
  value = vault_policy.policy.name
}
