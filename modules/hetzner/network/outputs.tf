output "hetzner_network" {
  description = "hetzner network"
  value       = hcloud_network.network
}

output "hetzner_subnets" {
  description = "hetzner subnets"
  value       = { for subnet in var.network_subnet_ranges : subnet => hcloud_network_subnet.subnet[subnet] }
}