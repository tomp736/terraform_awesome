resource "hcloud_server" "node" {
  # hetzner
  name        = var.node_config.name
  location    = var.node_config.location
  image       = var.node_config.image
  server_type = var.node_config.server_type

  # cloud-init
  user_data = "#cloud-config\n${var.cloud_init_user_data}"

  labels = {
    nodetype = var.node_config.nodetype
  }

  dynamic "network" {
    for_each = var.networks
    content {
      network_id = network.value.network_id
      ip         = network.value.ip
    }
  }

  public_net {
    ipv4_enabled = var.node_config.ipv4_enabled
    ipv6_enabled = var.node_config.ipv6_enabled
  }
}