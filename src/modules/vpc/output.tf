output "vpc_id" {
  value = yandex_vpc_network.vpc_network.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.vpc_subnet.id
}