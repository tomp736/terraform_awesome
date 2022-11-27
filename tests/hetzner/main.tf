# ./main.tf

module "hetzner_nodes" {
  for_each = { for node in local.nodes : node.id => node }

  source          = "./modules/hetzner/node"
  config_filepath = "files/node_config.json"
}