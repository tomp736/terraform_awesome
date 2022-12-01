# ./main.tf

locals {
  config   = jsondecode(file("files/config.json"))
  networks = local.config.networks
  nodes    = local.config.nodes
}

module "cloud_init" {
  source = "../../modules/cloud-init"
  general = {
    hostname                   = local.nodes[0].aws.name
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
  source       = "../../modules/aws/network"
  network_name = local.networks[0].aws.name
}

module "node" {
  source               = "../../modules/aws/node"
  node_config          = local.nodes[0].aws
  cloud_init_user_data = module.cloud_init.user_data
}