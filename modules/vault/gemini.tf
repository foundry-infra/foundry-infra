resource "kubernetes_namespace" "gemini" {
  metadata {
    name = "gemini"
  }
}

resource "helm_release" "gemini" {
  name       = "gemini"
  repository = "https://charts.fairwinds.com/stable/"
  chart      = "gemini"
  namespace  = "gemini"

  depends_on = [kubernetes_namespace.gemini]
}

resource "helm_release" "gemini_config" {
  chart = "${path.module}/gemini-config"
  name = "gemini-config"
  namespace  = helm_release.vault_primary.metadata.0.namespace
  depends_on = [helm_release.gemini]
}
