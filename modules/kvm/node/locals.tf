
locals {
  # CSV Lookup
  vm_sizes_data = { for inst in csvdecode(file("${path.module}/files/vm_size_lookup.csv")) : inst.size => inst }

  # JSON Lookup
  vm_config        = jsondecode(file(var.vm_config_filepath))
  vm_global        = local.vm_config.global
  vm_networks_data = { for inst in local.vm_config.networks : inst.iface => inst }
  vm_disks_data    = { for inst in local.vm_config.disks : inst.name => inst }
  vm_users_data    = { for inst in local.vm_config.users : inst.username => inst }

  # Lookup Vars
  vm_fqdn   = values(local.vm_networks_data)[0].hostname
  vm_size   = local.vm_sizes_data[local.vm_global.size]
  vm_memory = local.vm_size.memory
  vm_cpus   = local.vm_size.cpu

  # Constants
  vm_autostart = "true"
  vm_cpu_mode  = "host-model"

  # cloud-init network configuration
  cloud_init_network_config = replace(yamlencode({
    # network = {
    version  = 2
    renderer = "networkd"
    ethernets = {
      for vm_network in local.vm_networks_data : vm_network.iface =>
      {
        match = {
          macaddress = vm_network.mac
        }
        set-name        = vm_network.iface
        dhcp-identifier = "mac"
        dhcp4           = "true"
        link-local      = []
      }
    }
    # }
  }), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")

  # cloud-init metadata
  cloud_init_metadata = replace(yamlencode({
    local-hostname = split(".", values(local.vm_networks_data)[0].hostname)[0]
  }), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")

  cloud_init_user_data = replace(yamlencode({

    timezone                   = "Europe/Warsaw"
    package_update             = true
    package_upgrade            = true
    package_reboot_if_required = true
    final_message              = "The system is finally up, after $UPTIME seconds"
    power_state = {
      mode      = "reboot"
      message   = "Finished cloud init. Rebooting."
      condition = true
    }
    users = [
      for cloud_init_user in local.vm_users_data : merge(
        {
          name                = "${cloud_init_user.username}"
          shell               = "/bin/bash"
          ssh-authorized-keys = cloud_init_user.public_keys
        },
        cloud_init_user.username != "root" ? {
          sudo   = "ALL=(ALL) NOPASSWD:ALL"
          groups = "sudo"
          home   = "/home/${cloud_init_user.username}"
        } : {}
      )
    ]
    runcmd = [
      "mkdir -p /etc/ssh/sshd_config.d",
      "echo \"Port ${local.vm_global.ssh_port}\" > /etc/ssh/sshd_config.d/90-defaults.conf",
      "semanage port -a -t ssh_port_t -p tcp ${local.vm_global.ssh_port}"
    ]
  }), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")
}
