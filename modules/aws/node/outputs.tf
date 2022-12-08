output "ipv4_address" {
  value     = aws_instance.node.public_ip
  sensitive = true
}

output "id" {
  value     = aws_instance.node.id
  sensitive = true
}

output "name" {
  value     = var.node_config.name
  sensitive = true
}

output "nodetype" {
  value = var.node_config.nodetype
}