output "ipv4_address" {
  value     = aws_instance.node.public_ip
  sensitive = true
}

output "id" {
  value     = aws_instance.node.id
  sensitive = true
}

output "nodetype" {
  value = var.node_config.nodetype
}