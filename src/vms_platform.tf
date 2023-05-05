###############################################
#yandex_compute_instance_vm_web
###############################################
variable "vm_web_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_web_resources" {
  type   = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_web_scheduling_policy_preemptible" {
  type    = bool
  default = true
}

variable "vm_web_yandex_vpc_subnet_nat" {
  type    = bool
  default = true
}

variable "vm_web_metadata_serial_port_enable" {
  type    = number
  default = 1
}

variable "vm_web_metadata_ssh_keys_username" {
  type    = string
  default = "ubuntu"
}

###############################################
#yandex_compute_instance_vm_db
###############################################
variable "vm_db_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_db_resources" {
  type   = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm_db_scheduling_policy_preemptible" {
  type    = bool
  default = true
}

variable "vm_db_yandex_vpc_subnet_nat" {
  type    = bool
  default = true
}

variable "vm_db_metadata_serial_port_enable" {
  type    = number
  default = 1
}

variable "vm_db_metadata_ssh_keys_username" {
  type    = string
  default = "ubuntu"
}