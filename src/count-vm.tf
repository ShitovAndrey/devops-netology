###############################################
#yandex_compute_instance_vm_count
###############################################
resource "yandex_compute_instance" "vm_count" {
  count = 2
  
  name        = "vm-count-${count.index}"
  platform_id = var.vm_count_platform_id
  resources {
    cores         = var.vm_count_resources["cores"]
    memory        = var.vm_count_resources["memory"]
    core_fraction = var.vm_count_resources["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.compute_image.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_count_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_count_yandex_vpc_subnet_nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = "${var.vm_metadata["ssh-user"]}:${local.ssh_pub_key}"
  }
}