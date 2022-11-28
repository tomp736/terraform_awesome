# modules-terraform/modules/cloud-init/outputs.tf

output "user_data" {
  value = replace(yamlencode({

    timezone                   = var.general.timezone
    package_update             = var.general.package_update
    package_upgrade            = var.general.package_upgrade
    package_reboot_if_required = var.general.package_reboot_if_required
    final_message              = var.general.final_message
    power_state = {
      mode      = var.general.power_state.mode
      message   = var.general.power_state.message
      condition = var.general.power_state.condition
    }
    users = [
      for user in var.users_data : merge(
        {
          name                = user.name
          shell               = user.shell
          ssh-authorized-keys = user.ssh-authorized-keys
        },
        user.name != "root" ? {
          sudo   = "ALL=(ALL) NOPASSWD:ALL"
          groups = "sudo"
          home   = "/home/${user.name}"
        } : {}
      )
    ]
    runcmd = var.runcmd
  }), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")
}

output "metadata" {
  value = replace(yamlencode({
    local-hostname = split(".", var.general.hostname)
  }), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")
}

output "network_config" {
  value = replace(yamlencode({
    version   = var.networks_data.version
    renderer  = var.networks_data.renderer
    ethernets = var.networks_data.ethernets
  }), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")
}