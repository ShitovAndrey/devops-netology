resource "yandex_compute_disk" "additional_disks" {
  count = 3

  name = "add-disk${count.index}"
  type = "network-hdd"
  size = 1
}

###############################################
#yandex_compute_instance_vm_add
###############################################
resource "yandex_compute_instance" "vm_add" {
  depends_on = [ yandex_compute_disk.additional_disks ]
  
  name        = "vm-add"
  platform_id = var.vm_count_platform_id
  resources {
    cores         = var.vm_add_resources["cores"]
    memory        = var.vm_add_resources["memory"]
    core_fraction = var.vm_add_resources["core_fraction"]
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.additional_disks
    content {
        disk_id = secondary_disk.value["id"]
    } 
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.compute_image.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_add_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_add_yandex_vpc_subnet_nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = "${var.vm_metadata["ssh-user"]}:${local.ssh_pub_key}"
  }
}