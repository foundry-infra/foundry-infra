include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/vault"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_uuid = "1234"
  }
}

dependency "k8s" {
  config_path = "../k8s"
  mock_outputs = {
    k8s_endpoint = "http://foo.bar"
    k8s_token = "djfklsdjlfksd"
    k8s_cluster_ca_certificate_b64d = "dfjlksdjfl"
  }
}

inputs = {
  k8s_endpoint = dependency.k8s.outputs.k8s_endpoint
  k8s_token = dependency.k8s.outputs.k8s_token
  k8s_cluster_ca_certificate_b64d = dependency.k8s.outputs.k8s_cluster_ca_certificate_b64d
}
