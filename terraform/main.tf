#Сеть
resource "yandex_vpc_network" "net-lesson" {
  name = "net-lesson"
}
#Резервируем один статический ip адрес для proxy
resource "yandex_vpc_address" "static_ip" {
  name = "public-proxy-ip"
  external_ipv4_address {
    zone_id = var.zone
  }
}
#Создаем NAT-шлюз
resource "yandex_vpc_gateway" "nat_gateway_for_net_lesson" {
  name = "nat-gateway-for-net-lesson"
  shared_egress_gateway {}
}
#Прописываем правио в таблицу маршрутизации
resource "yandex_vpc_route_table" "nat_route_table" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.net-lesson.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway_for_net_lesson.id
  }
}
#Создаем подсеть
resource "yandex_vpc_subnet" "subnet-lesson" {
  name           = "subnet-lesson"
  zone           = var.zone
  network_id     = yandex_vpc_network.net-lesson.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  route_table_id = yandex_vpc_route_table.nat_route_table.id
}

#БЛОК COMPUTE
#Создаем загрузочные диски
resource "yandex_compute_disk" "boot-disk" {
  for_each = var.virtual_machines
  name     = each.value["disk_name"]
  type     = "network-hdd"
  zone     = var.zone
  size     = each.value["disk_size"]
  image_id = var.template
}

#ВМ со статическим публичным IP
resource "yandex_compute_instance" "vm_with_public_ip" {
  name        = var.virtual_machines[var.vm_with_public_ip].vm_name
  description = var.virtual_machines[var.vm_with_public_ip].vm_desc
  zone        = var.zone

  resources {
    cores         = var.virtual_machines[var.vm_with_public_ip].vm_cpu
    memory        = var.virtual_machines[var.vm_with_public_ip].ram
    core_fraction = var.virtual_machines[var.vm_with_public_ip].vm_fraction
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk[var.vm_with_public_ip].id
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet-lesson.id
    nat            = true
    nat_ip_address = yandex_vpc_address.static_ip.external_ipv4_address[0].address
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

#Остальные ВМ без публичного IP
resource "yandex_compute_instance" "virtual_machine" {
  for_each = {
    for k, v in var.virtual_machines : k => v
    if k != var.vm_with_public_ip
  }

  name        = each.value.vm_name
  description = each.value.vm_desc
  zone        = var.zone

  resources {
    cores         = each.value.vm_cpu
    memory        = each.value.ram
    core_fraction = each.value.vm_fraction
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk[each.key].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-lesson.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}
