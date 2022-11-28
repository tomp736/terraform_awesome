# ./main.tf

module "network" {
  source = "../../modules/hetzner/network"
}

module "cloud_init" {
  source = "../../modules/cloud-init"

  general = {
    hostname                   = "test"
    package_reboot_if_required = true
    package_update             = true
    package_upgrade            = true
    timezone                   = "Europe/Warsaw"
  }

}

module "node" {
  source               = "../../modules/hetzner/node"
  config_filepath      = "files/node_config.json"
  cloud_init_user_data = module.cloud_init.user_data
}