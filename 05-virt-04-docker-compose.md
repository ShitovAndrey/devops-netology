# Домашнее задание к занятию 4. «Оркестрация группой Docker-контейнеров на примере Docker Compose»
1. Создайте собственный образ любой операционной системы (например ubuntu-20.04) с помощью Packer.

   Скриншот task1-create-image.png прилогается.

2. Создать ВМ средствами terraform

   Скриншот task2-create-vm.png прилогается.
   ```
   root@ubu18:~/netology/terraform# terraform apply
   
   Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
     + create
   
   Terraform will perform the following actions:
   
     # yandex_compute_instance.node01 will be created
     + resource "yandex_compute_instance" "node01" {
         + allow_stopping_for_update = true
         + created_at                = (known after apply)
         + folder_id                 = (known after apply)
         + fqdn                      = (known after apply)
         + hostname                  = "node01.netology.cloud"
         + id                        = (known after apply)
         + metadata                  = {
             + "ssh-keys" = <<-EOT
                   centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQotiza/qp4b2oc24iznMo9EwGxrUDkDQWD/LbIrjiXCWKLdJawofq0p7nuMgmshFR3RdKV0rogSmRXUR+8u4jKJgcfB9urApL5K7SAbkhEdSonxbIiGNfstnKEBWRCa5tFCJwJpzEkcv4HDFjACxAbfost77mp1AmcPTCgDAG9gpY1ZOA1o2d0XijxX7MD0Hq/c6iSEXEfp+0SVb1f4J7Fq+v6LyaldOx33185AueqbIdK9czaBsciHJXwAQc/KaHQDESt5Q4kJEfIEmxFdl+UjGCxzio5yhkZelZxjef+qyz2TLNCal4LGZCcbyyeIiLaExsRYAiWdYQV6ObSmggj0pcHN0RM29lGgTNktmi7uGwPQl6noKHcAhOGHnktX4oXp8QgeAvZpcX8WeoD89/JW1B+kuKHX038dmoNVMZgpeRG1TUhlm5wf1NyKw3VxtM2TZSxRBI19rz0cRGKoRWyavX4T1bwFrj+TgXNM3DFmcBD2pSs+htQuMuHRcfHVrnnoL5I5kGOx4438No69zZJ8xC3+jKUc1ClRbuIEaiOyl2O+LIKwXr69cx1dMDiQsR+2ls/bF4V0mb2cWleVnkFaSJD8LraB1vfI8ZNNnVEpOWAdvCb+NIWdyLMvWgHS8pVemg3dHZPir1WBp0WvWl4ycpoy7N0SZNJWEAQg+Ivw== root@ubu18
               EOT
           }
         + name                      = "node01"
         + network_acceleration_type = "standard"
         + platform_id               = "standard-v1"
         + service_account_id        = (known after apply)
         + status                    = (known after apply)
         + zone                      = "ru-central1-a"
   
         + boot_disk {
             + auto_delete = true
             + device_name = (known after apply)
             + disk_id     = (known after apply)
             + mode        = (known after apply)
   
             + initialize_params {
                 + block_size  = (known after apply)
                 + description = (known after apply)
                 + image_id    = "fd8abnb4e0sc5upl8c5j"
                 + name        = "root-node01"
                 + size        = 50
                 + snapshot_id = (known after apply)
                 + type        = "network-nvme"
               }
           }
   
         + network_interface {
             + index              = (known after apply)
             + ip_address         = (known after apply)
             + ipv4               = true
             + ipv6               = (known after apply)
             + ipv6_address       = (known after apply)
             + mac_address        = (known after apply)
             + nat                = true
             + nat_ip_address     = (known after apply)
             + nat_ip_version     = (known after apply)
             + security_group_ids = (known after apply)
             + subnet_id          = (known after apply)
           }
   
         + resources {
             + core_fraction = 100
             + cores         = 8
             + memory        = 8
           }
       }
   
     # yandex_vpc_network.default will be created
     + resource "yandex_vpc_network" "default" {
         + created_at                = (known after apply)
         + default_security_group_id = (known after apply)
         + folder_id                 = (known after apply)
         + id                        = (known after apply)
         + labels                    = (known after apply)
         + name                      = "net"
         + subnet_ids                = (known after apply)
       }
   
     # yandex_vpc_subnet.default will be created
     + resource "yandex_vpc_subnet" "default" {
         + created_at     = (known after apply)
         + folder_id      = (known after apply)
         + id             = (known after apply)
         + labels         = (known after apply)
         + name           = "subnet"
         + network_id     = (known after apply)
         + v4_cidr_blocks = [
             + "192.168.101.0/24",
           ]
         + v6_cidr_blocks = (known after apply)
         + zone           = "ru-central1-a"
       }
   
   Plan: 3 to add, 0 to change, 0 to destroy.
   
   Changes to Outputs:
     + external_ip_address_node01_yandex_cloud = (known after apply)
       + internal_ip_address_node01_yandex_cloud = (known after apply)
   
   Do you want to perform these actions?
     Terraform will perform the actions described above.
     Only 'yes' will be accepted to approve.
   
     Enter a value: yes
   
   yandex_vpc_network.default: Creating...
   yandex_vpc_network.default: Creation complete after 1s [id=enpmfcbd0u5ub54t7r2j]
   yandex_vpc_subnet.default: Creating...
   yandex_vpc_subnet.default: Creation complete after 0s [id=e9bfjn7e02pvqbladh31]
   yandex_compute_instance.node01: Creating...
   yandex_compute_instance.node01: Still creating... [10s elapsed]
   yandex_compute_instance.node01: Still creating... [20s elapsed]
   yandex_compute_instance.node01: Still creating... [30s elapsed]
   yandex_compute_instance.node01: Still creating... [40s elapsed]
   yandex_compute_instance.node01: Still creating... [50s elapsed]
   yandex_compute_instance.node01: Still creating... [1m0s elapsed]
   yandex_compute_instance.node01: Still creating... [1m10s elapsed]
   yandex_compute_instance.node01: Creation complete after 1m15s [id=fhma87poilsc0bro2oah]
   
   Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
   
   Outputs:
   
   external_ip_address_node01_yandex_cloud = "158.160.36.135"
   internal_ip_address_node01_yandex_cloud = "192.168.101.16"
   
   ```

3. С помощью Ansible и Docker Compose разверните на виртуальной машине систему мониторинга на основе Prometheus/Grafana.
   ``` bash
   [root@node01 stack]# docker-compose ps
       Name                  Command                  State                                                   Ports
   -------------------------------------------------------------------------------------------------------------------------------------------------------------
   alertmanager   /bin/alertmanager --config ...   Up             9093/tcp
   caddy          /sbin/tini -- caddy -agree ...   Up             0.0.0.0:3000->3000/tcp, 0.0.0.0:9090->9090/tcp, 0.0.0.0:9091->9091/tcp, 0.0.0.0:9093->9093/tcp
   cadvisor       /usr/bin/cadvisor -logtostderr   Up (healthy)   8080/tcp
   grafana        /run.sh                          Up             3000/tcp
   nodeexporter   /bin/node_exporter --path. ...   Up             9100/tcp
   prometheus     /bin/prometheus --config.f ...   Up             9090/tcp
   pushgateway    /bin/pushgateway                 Up             9091/tcp
   
   [root@node01 stack]# docker ps
   CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS                        PORTS                                                                              NAMES
   a4bbaf75a473   prom/alertmanager:v0.20.0          "/bin/alertmanager -…"   2 minutes ago   Up About a minute             9093/tcp                                                                           alertmanager
   700c4a506201   stefanprodan/caddy                 "/sbin/tini -- caddy…"   2 minutes ago   Up About a minute             0.0.0.0:3000->3000/tcp, 0.0.0.0:9090-9091->9090-9091/tcp, 0.0.0.0:9093->9093/tcp   caddy
   c4fdd488dbdc   gcr.io/cadvisor/cadvisor:v0.47.0   "/usr/bin/cadvisor -…"   2 minutes ago   Up About a minute (healthy)   8080/tcp                                                                           cadvisor
   d778d3b1c6b8   prom/prometheus:v2.17.1            "/bin/prometheus --c…"   2 minutes ago   Up About a minute             9090/tcp                                                                           prometheus
   30479344535d   prom/pushgateway:v1.2.0            "/bin/pushgateway"       2 minutes ago   Up About a minute             9091/tcp                                                                           pushgateway
   3438911529bc   grafana/grafana:7.4.2              "/run.sh"                2 minutes ago   Up About a minute             3000/tcp                                                                           grafana
   f0cf4dae5703   prom/node-exporter:v0.18.1         "/bin/node_exporter …"   2 minutes ago   Up About a minute             9100/tcp                                                                           nodeexporter
   [root@node01 stack]# 
   ```
4. Скриншот работающего веб-интерфейса Grafana с текущими метриками.

   Скриншот task4-monitoring.png прилогается.