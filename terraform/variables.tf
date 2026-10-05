variable "virtual_machines" {
  type = map(object({
    vm_name     = string
    vm_desc     = string
    vm_cpu      = number
    vm_fraction = number
    ram         = number
    disk_size   = number
    disk_name   = string
  }))
}

variable "zone" {
  type        = string
  description = "Зона доступности"
  default     = "ru-central1-a"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Путь к публичному SSH-ключу"
  default     = "/home/dborohtyanov/.ssh/id_ed25519.pub"
}

variable "template" {
  type        = string
  description = "ID образа загрузочного диска"
  default     = "fd8k6or569jh7bsajilr"
}

variable "vm_with_public_ip" {
  type        = string
  description = "Ключ ВМ, которой нужен публичный статический ip"
}

variable "folder_id" {
  type       = string
  default    =  "b1g1n6otae7nsefs4auq"
}
