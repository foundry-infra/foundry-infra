output "lb_ip" {
  value = data.kubernetes_service.lb.load_balancer_ingress.0.ip
}
