output "vm_web_nat_ip_addr" {
  value = yandex_compute_instance.vm_web.network_interface[0].nat_ip_address
}

output "vm_db_nat_ip_addr" {
  value = yandex_compute_instance.vm_db.network_interface[0].nat_ip_address
}