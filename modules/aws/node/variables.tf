variable "node_config" {
  description = "node config"
  type = object({
    name        = string,
    location    = string,
    image       = string,
    server_type = string,
    nodetype    = string,
    ssh_user    = string,
    ssh_port    = string
  })
}

variable "cloud_init_user_data" {
  description = "cloud init user data"
  type        = string
}