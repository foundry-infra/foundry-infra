include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/k8s"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_uuid = "1234"
  }
}

inputs = {
  cluster_name = "moose"
  vpc_uuid = dependency.vpc.outputs.vpc_uuid
}
