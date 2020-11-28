output "vpc_uuid" {
  value = module.vpc.vpc_uuid
}

output "k8s_endpoint" {
  value = module.cluster.k8s_endpoint
}

output "k8s_token" {
  value = module.cluster.k8s_token
}

output "k8s_cluster_ca_certificate_b64d" {
  value = module.cluster.k8s_cluster_ca_certificate_b64d
}

output "workaround_subdomain_name" {
  value = module.ingress_workaround_dns.workaround_subdomain_name
}
