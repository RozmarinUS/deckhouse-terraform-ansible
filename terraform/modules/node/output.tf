output "ip_address" {
   value = var.interface_1_ips[*]
}

output "admin_username" {
   value = var.user
}
