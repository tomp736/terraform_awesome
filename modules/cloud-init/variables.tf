# modules-terraform/modules/cloud-init/variables.tf

variable "general" {
  type = object({
    hostname                   = optional(string, "hostname"),
    timezone                   = optional(string, "UTC"),
    package_update             = optional(bool, true),
    package_upgrade            = optional(bool, true),
    package_reboot_if_required = optional(bool, true),
    final_message              = optional(string, "The system is finally up, after $UPTIME seconds")
    power_state = optional(object({
      mode      = optional(string, "reboot"),
      message   = optional(string, "Finished cloud init. Rebooting."),
      condition = optional(bool, true)
      }), {
      mode           = "reboot",
      message        = "Finished cloud init. Rebooting.",
      network_config = true
    })
  })
}

variable "networks_data" {
  type = object({
    version  = optional(number, 2),
    renderer = optional(string, "networkd")
    ethernets = optional(list(object({
      match = object({
        macaddress = string
      })
      set-name        = string,
      dhcp-identifier = string,
      dhcp4           = bool,
      link-local      = list(string)
    })))
  })
  default = {
    ethernets = []
    version   = 2
    renderer  = "networkd"
  }
}

variable "users_data" {
  type = list(object(
    {
      name                = string,
      shell               = string
      ssh-authorized-keys = list(string)
    }
  ))
  default = [{
    name                = "root"
    shell               = "/bin/bash"
    ssh-authorized-keys = []
  }]
  sensitive = true
}

variable "runcmd" {
  type      = list(string)
  default   = []
  sensitive = true
}