output "ipv4_address" {
  value     = hcloud_server.node.ipv4_address
  sensitive = true
}

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