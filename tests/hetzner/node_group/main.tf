module "networks" {
  for_each = local.config_networks
  source   = "../../../modules/hetzner/network"

  network_name          = each.value.name
  network_ip_range      = each.value.ip_range
  network_subnet_ranges = each.value.subnet_ranges
}

module "node_group" {
  source = "../../../modules/hetzner/node_group"
  nodes  = local.config_nodes
  public_keys = [
    var.github_public_key
  ]
  networks_map = { for config_network in local.config_networks : config_network.id =>
    {
      name       = config_network.id,
      hetzner_id = module.networks[config_network.id].hetzner_network.id
    }
  }
}
