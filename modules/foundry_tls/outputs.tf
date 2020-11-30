output "secret_name" {
  value = kubernetes_secret.secret.metadata.0.name
}
