# ./variables.tf

variable "nodes" {
  description = "(Required) - Nodes configuration."
  type        = any
}

variable "bastion_host" {
  description = "(Optional) - Bastion host for connection."
  type        = string
  default     = null
}

variable "sshd_config" {
  description = "(Optional) - SSH configuration settings."
  type = object({
    ssh_port = string
    ssh_user = string
  })
}

variable "public_keys" {
  description = "(Required) - Public keys."
  type        = list(string)
  sensitive   = true
}

variable "networks_map" {
  description = "(Required) - Map of network names to ids."
  type = map(object(
    {
      name       = string
      hetzner_id = string
    }
  ))
}