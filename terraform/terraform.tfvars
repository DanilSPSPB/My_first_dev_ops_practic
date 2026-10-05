virtual_machines = {
  "vm-proxy-1" = {
    vm_name     = "vm-proxy-1"
    vm_desc     = "первая виртуальная машина - nginx-proxy"
    vm_cpu      = 2
    vm_fraction = 100
    ram         = 2
    disk_size   = 20
    disk_name   = "ubuntu-proxy-1"
  }
  "vm-web-1" = {
    vm_name     = "vm-web-1"
    vm_desc     = "первая виртуальная машина-web-server"
    vm_cpu      = 2
    vm_fraction = 20
    ram         = 1
    disk_size   = 20
    disk_name   = "ubuntu-web-1"
  }
  "vm-web-2" = {
    vm_name     = "vm-web-2"
    vm_desc     = "третья виртуальная машина-web-server"
    vm_cpu      = 2
    vm_fraction = 20
    ram         = 1
    disk_size   = 20
    disk_name   = "ubuntu-web-2"
  }
}

vm_with_public_ip = "vm-proxy-1"
