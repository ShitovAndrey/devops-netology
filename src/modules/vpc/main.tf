########################################################
#                     NETWORK
########################################################
resource "yandex_vpc_network" "vpc_network" {
  name = var.env_name
}
resource "yandex_vpc_subnet" "vpc_subnet" {
  name           = var.env_name
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc_network.id
  v4_cidr_blocks = var.cidr
}