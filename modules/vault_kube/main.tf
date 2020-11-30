terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
  }
}
variable "pat" {}
resource "vault_auth_backend" "kubernetes" {
  path = "kubernetes"
  type = "kubernetes"
}
