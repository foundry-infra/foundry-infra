terraform {
  source = "git@github.com:foundry-infra/foundry-infra.git//modules/platform?ref=v0.0.3"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_name = "ruste-dev"
  cluster_name = "ruste-dev-apps"
  project_name = "mackenzie.a.z.c"
  vault_domain = "goldengulp.com"
  vault_issuer_name = "letsencrypt-staging"
  vault_subdomain_name = "vault.goldengulp.com"
  k8s_version = "1.19.3-do.2"
  digitalocean_api_token = "${get_env("TF_VAR_DO_TOKEN", "")}"
}
