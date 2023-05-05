###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###ssh vars
variable "vm_metadata" {
  type = map
  default = {
    ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnj+Iurh5zYW5983pk5CGye+SLfKpRPGzYUJrf2ikl8 andy@ubu18"
    ssh-user           = "ubuntu"
    serial-port-enable = 1
  }
}

###yandex_compute_image
variable "compute_image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

###for locals
variable "env" {
  type        = string
  default     = "develop"
}

variable "project" {
  type    = string
  default = "platform"
}