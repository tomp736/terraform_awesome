resource "hcloud_server" "node" {
  # hetzner
  name        = var.node_config.name
  location    = var.node_config.location
  image       = var.node_config.image
  server_type = var.node_config.server_type

  start_after_create = true

  # cloud-init
  user_data = "#cloud-config\n${var.cloud_init_user_data}"

  labels = {
    nodetype = var.node_config.nodetype
  }

  dynamic "network" {
    for_each = var.network_ids
    content {
      network_id = network.value
    }
  }

  public_net {
    ipv4_enabled = var.node_config.ipv4_enabled
    ipv6_enabled = var.node_config.ipv6_enabled
  }
}