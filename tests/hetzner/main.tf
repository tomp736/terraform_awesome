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
        var.github_public_key,
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExbodob3iNOPTRsZms/Gjp8PTWnU5fqc1TJEKpTLXIA u0@s01",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILDxJpolhuDKTr4KpXnq5gPTKYUnoKyAnpIR4k5m3XCH u0@prt-dev-01",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwIzhRR2PLaScPBSBS2cfN9dthkdiB5ZvhkFNMpT+6G u0@prt-dev-01",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgBAq+CCGT/of2ROoB1+1NiYqrWSSKrptvD7D7NIYM8 gitlab@gitlab.labrats.work"
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
  node_config          = jsondecode(file("files/node_config.json"))
  cloud_init_user_data = module.cloud_init.user_data
}