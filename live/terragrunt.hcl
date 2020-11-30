generate "s3_backend" {
  path      = "backend.generated.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket      = "platform-foundry"
    key         = "${path_relative_to_include()}/terraform.tfstate"
    access_key = "${get_env("TF_VAR_DO_SPACES_KEY", "")}"
    secret_key = "${get_env("TF_VAR_DO_SPACES_SECRET", "")}"
    region = "us-west-1"
    endpoint = "sfo2.digitaloceanspaces.com"
    skip_credentials_validation = true
    # skip_get_ec2_platforms = true
    # skip_requesting_account_id = true
    skip_metadata_api_check = true
  }
  required_version = "~> 0.13.4"
}
EOF
}
