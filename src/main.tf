########################################################
#                     NETWORK
########################################################
module "vpc_dev" {
  source       = "./modules/vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = ["10.0.1.0/24"]
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

########################################################
#                     VM
########################################################
module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=1.0.0"
  env_name        = "develop"
  network_id      = module.vpc_dev.vpc_id
  subnet_zones    = ["ru-central1-a"]
  subnet_ids      = [ module.vpc_dev.subnet_id ]
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = false
  security_group_ids = [yandex_vpc_security_group.example.id]


  metadata = {
      user-data          = data.template_file.cloudinit.rendered
      serial-port-enable = 1
  }

}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  
  vars = {
    tmpl_ssh_public_key      = local.ssh_pub_key
    tmpl_cloud_init_packages = jsonencode(var.cloud_init_packages)
  }
}