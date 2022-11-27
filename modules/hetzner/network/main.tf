resource "hcloud_network" "network" {
  name     = var.network_name
  ip_range = var.network_ip_range
}

resource "hcloud_network_subnet" "subnet" {
  for_each = { for subnet in var.network_subnet_ranges : subnet => subnet }

  network_id   = hcloud_network.network.id
  type         = "server"
  network_zone = var.network_zone
  ip_range     = each.value
}