terraform {
  source = "../../../modules/platform"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  vpc_name = "ruste-dev"
  cluster_name = "ruste-dev-apps"
  project_name = "mackenzie.a.z.c"
  vault_domain = "goldengulp.com"
  k8s_version = "1.19.3-do.2"
}
