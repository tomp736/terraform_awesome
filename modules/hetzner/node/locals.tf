locals {
  node_config = jsondecode(var.node_config_json)
  hetzner     = local.node_config.hetzner
}