# ./main.tf

module "network" {
  source       = "../../modules/hetzner/network"
  network_name = var.test_id
}

module "cloud_init" {
  source = "../../modules/cloud-init"
  general = {
    hostname                   = var.test_id
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

module "node" {
  source               = "../../modules/hetzner/node"
  node_config          = jsondecode(file("files/config.json")).nodes[0].hetzner
  cloud_init_user_data = module.cloud_init.user_data
}