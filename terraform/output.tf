output "public_ip_addr_proxy_vm" {
  value       = yandex_vpc_address.static_ip.external_ipv4_address[0].address
  description = "Публичный статический IP прокси-машины"
}

output "internal_ip_proxy_vm" {
  value       = yandex_compute_instance.vm_with_public_ip.network_interface[0].ip_address
  description = "Внутренний IP прокси-машины"
}

output "internal_ip_web_vm" {
  value = {
    for k, v in yandex_compute_instance.virtual_machine : k => v.network_interface[0].ip_address
  }
  description = "Внутренние IP web-машин"
}

output "id_web_vm" {
  value = {
    for k, v in yandex_compute_instance.virtual_machine : k => v.id
  }
  description = "ID web-серверов"
}

output "id_proxy_vm" {
  value       = yandex_compute_instance.vm_with_public_ip.id
  description = "ID proxy-сервера"


}
