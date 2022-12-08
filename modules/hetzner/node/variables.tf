variable "node_config" {
  description = "node config"
  type = object({
    name         = string,
    location     = string,
    image        = string,
    server_type  = string,
    ipv4_enabled = optional(bool, true),
    ipv6_enabled = optional(bool, true),
    nodetype     = string,
    ssh_user     = string,
    ssh_port     = string
  })
}

variable "networks" {
  description = "networks to connect to"
  type = list(object({
    name = string
    id   = string
  }))
}

variable "cloud_init_user_data" {
  description = "cloud init user data"
  type        = string
}