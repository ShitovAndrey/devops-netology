resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
        vm_count    =  yandex_compute_instance.vm_count
        vm_for_each =  yandex_compute_instance.vm_for_each
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}