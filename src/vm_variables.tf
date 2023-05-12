###############################################
#yandex_compute_instance_vm_count
###############################################
variable "vm_count_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_count_resources" {
  type   = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_count_scheduling_policy_preemptible" {
  type    = bool
  default = true
}

variable "vm_count_yandex_vpc_subnet_nat" {
  type    = bool
  default = true
}

###############################################
#yandex_compute_instance_vm_for_each
###############################################
variable "vm_for_each_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_for_each_resources_list" {
    type = list(object(
      {
        vm_name = string,
        cpu     = number,
        ram     = number,
        disk    = number,
        core_fraction = number
      }
      ))
    
    default = [
        {
            vm_name = "v1"
            cpu     = 2
            ram     = 1
            disk    = 0
            core_fraction = 5
        },
        {
            vm_name = "v2"
            cpu     = 2
            ram     = 2
            disk    = 0
            core_fraction = 5
        },
     ]
}

variable "vm_for_each_scheduling_policy_preemptible" {
  type    = bool
  default = true
}

variable "vm_for_each_yandex_vpc_subnet_nat" {
  type    = bool
  default = true
}

###############################################
#yandex_compute_instance_vm_add
###############################################
variable "vm_add_platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_add_resources" {
  type   = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_add_scheduling_policy_preemptible" {
  type    = bool
  default = true
}

variable "vm_add_yandex_vpc_subnet_nat" {
  type    = bool
  default = true
}