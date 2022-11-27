module "vms" {
  source          = "../../modules/kvm/node"
  config_filepath = "files/node_config.json"
}