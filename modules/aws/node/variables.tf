variable "node_config" {
  description = "node config"
  type = object({
    name          = string,
    image         = string,
    instance_type = string,
    nodetype      = string,
    ssh_user      = string,
    ssh_port      = string
  })
}

variable "network_interface_config" {
  description = "network interface config"
  type = list(object({
    device_index         = number,
    network_interface_id = string,
  }))
  default = []
}

variable "cloud_init_user_data" {
  description = "cloud init user data"
  type        = string
}