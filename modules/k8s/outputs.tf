output "k8s_endpoint" {
  value = digitalocean_kubernetes_cluster.main.endpoint
}

output "k8s_token" {
  value = digitalocean_kubernetes_cluster.main.kube_config[0].token
}

output "k8s_cluster_ca_certificate_b64d" {
  value = base64decode(digitalocean_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
}

output "ingress_ip" {
  value = digitalocean_floating_ip.ingress_ip.ip_address
}
