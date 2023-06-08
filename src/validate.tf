variable "simple_ip" {
    type = string
    description = "ip-адрес"
#    default = "1920.1680.0.1"
    default = "192.168.0.1"
    validation {
      condition = can(cidrhost("${var.simple_ip}/32", 0))
      error_message = "Validation error: The simple_ip value must be a valid ip address."
    }
}

variable "list_ip" {
  type = list(string)
  description = "список ip-адресов"
#  default = ["192.168.0.1", "1.1.1.1", "1270.0.0.1"]
  default = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]
  validation {
    condition = alltrue(
        [ for ip_addr in var.list_ip : can(cidrhost("${ip_addr}/32", 0)) ]
      )
    error_message = "Validation error: The list_ip must be a valid ip address."
  }
}