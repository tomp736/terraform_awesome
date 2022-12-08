# ./main.tf

locals {
  config   = jsondecode(file("files/config.json"))
  networks = local.config.networks
  nodes    = local.config.nodes
}

module "cloud_init" {
  source = "../../modules/cloud-init"
  general = {
    hostname                   = local.nodes[0].hetzner.name
    package_reboot_if_required = true
    package_update             = true
    package_upgrade            = true
    timezone                   = "Europe/Warsaw"
  }
  users_data = [
    {
      name  = "sysadmin"
      shell = "/bin/bash"
      ssh-authorized-keys = [
        var.github_public_key
      ]
    }
  ]
  runcmd = [
    "mkdir -p /etc/ssh/sshd_config.d",
    "echo \"Port 2222\" > /etc/ssh/sshd_config.d/90-defaults.conf"
  ]
}

module "network" {
  source       = "../../modules/hetzner/network"
  network_name = local.networks[0].hetzner.name
}

module "node" {
  source = "../../modules/hetzner/node"

  depends_on = [
    module.network
  ]

  node_config = local.nodes[0].hetzner
  networks = [
    {
      name = local.networks[0].hetzner.id
      id   = module.network[local.networks[0].hetzner.id].hetzner_network.id
    }
  ]
  cloud_init_user_data = module.cloud_init.user_data
}