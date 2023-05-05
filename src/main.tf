resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "compute_image" {
  family = var.compute_image_family
}

###############################################
#yandex_compute_instance_vm_web
###############################################
resource "yandex_compute_instance" "vm_web" {
  name        = local.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_resources["cores"]
    memory        = var.vm_web_resources["memory"]
    core_fraction = var.vm_web_resources["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.compute_image.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_yandex_vpc_subnet_nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = "${var.vm_metadata["ssh-user"]}:${var.vm_metadata["ssh-keys"]}"
  }

}

###############################################
#yandex_compute_instance_vm_db
###############################################
resource "yandex_compute_instance" "vm_db" {
  name        = local.vm_db_name
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vm_db_resources["cores"]
    memory        = var.vm_db_resources["memory"]
    core_fraction = var.vm_db_resources["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.compute_image.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_db_yandex_vpc_subnet_nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata["serial-port-enable"]
    ssh-keys           = "${var.vm_metadata["ssh-user"]}:${var.vm_metadata["ssh-keys"]}"
  }

}