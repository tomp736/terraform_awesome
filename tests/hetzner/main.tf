# ./main.tf

module "hetzner_nodes" {
  source          = "../../modules/hetzner/node"
  config_filepath = "files/node_config.json"
}