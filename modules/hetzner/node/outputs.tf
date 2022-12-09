output "id" {
  value     = hcloud_server.node.id
  sensitive = true
}

output "name" {
  value     = var.node_config.name
  sensitive = true
}

output "nodetype" {
  value = var.node_config.nodetype
}

output "ipv4_address" {
  value     = hcloud_server.node.ipv4_address
  sensitive = true
}

output "networks" {
  value = {
    for network in hcloud_server.node.network : network.network_id => {
      network_id  = network.network_id
      mac_address = network.mac_address
      ip          = network.ip
    }
  }
}