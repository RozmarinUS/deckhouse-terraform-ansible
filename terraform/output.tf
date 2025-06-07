output "ip_address_lb_1" {
  value = module.loadbalancer.ip_address[0]
}


output "ip_address_kube_master_1" {
  value = module.master.ip_address[0]
}


output "ip_address_kube_ingress_1" {
  value = module.ingress.ip_address[0]
}


output "ip_address_kube_worker_1" {
  value = module.worker.ip_address[0]
}


output "admin_username" {
  value = module.master.admin_username
}

output "k8s_control_plane_endpoint" {
  value = module.loadbalancer.ip_address[0]
}

output "k8s_ingress_endpoint" {
  value = module.loadbalancer.ip_address[0]
}
