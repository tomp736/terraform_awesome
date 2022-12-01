# ./main.tf

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
  source               = "../../modules/aws/node"
  node_config          = jsondecode(file("files/node_config.json")).aws
  cloud_init_user_data = module.cloud_init.user_data
}