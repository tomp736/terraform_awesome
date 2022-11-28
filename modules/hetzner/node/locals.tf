locals {
  node_config = jsondecode(file(var.config_filepath))
  hetzner     = local.node_config.hetzner
}