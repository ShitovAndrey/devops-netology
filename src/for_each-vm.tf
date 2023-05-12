###############################################
#yandex_compute_instance_vm_for_each
###############################################
resource "yandex_compute_instance" "vm_for_each" {
  depends_on = [ yandex_compute_instance.vm_count ]

  for_each   = {
    for index, vm in var.vm_for_each_resources_list:
    vm.vm_name => vm
  }

  name        = "vm-count-${each.value.vm_name}"
  platform_id = var.vm_for_each_platform_id
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.compute_image.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_for_each_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_for_each_yandex_vpc_subnet_nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = "${var.vm_metadata["ssh-user"]}:${local.ssh_pub_key}"
  }
}