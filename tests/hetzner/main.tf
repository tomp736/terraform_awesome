# ./main.tf

module "network" {
  source = "../../modules/hetzner/network"
}

module "node" {
  source          = "../../modules/hetzner/node"
  config_filepath = "files/node_config.json"
}