resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
        vm_count    =  yandex_compute_instance.vm_count
        vm_for_each =  yandex_compute_instance.vm_for_each
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}

locals {
  output_vm_count = [
    for inst in yandex_compute_instance.vm_count : {
      fqdn = inst.fqdn
      id   = inst.id
      name = inst.name
    }
  ]

  output_vm_for_each = [
    for inst in yandex_compute_instance.vm_for_each : {
      fqdn = inst.fqdn
      id   = inst.id
      name = inst.name
    }
  ]

  output_vm_add = [
    {
      fqdn = yandex_compute_instance.vm_add.fqdn
      id   = yandex_compute_instance.vm_add.id
      name = yandex_compute_instance.vm_add.name
    }
  ]
}


output "vm_output" { 
  value = flatten([local.output_vm_count, local.output_vm_for_each, local.output_vm_add])
}