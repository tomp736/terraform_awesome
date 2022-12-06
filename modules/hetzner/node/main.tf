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

  public_net {
    ipv4_enabled = var.node_config.ipv4_enabled
    ipv6_enabled = var.node_config.ipv6_enabled
  }
}

resource "null_resource" "cloud-init" {
  depends_on = [
    hcloud_server.node
  ]

  connection {
    host    = hcloud_server.node.ipv4_address
    agent   = true
    user    = var.node_config.ssh_user
    port    = var.node_config.ssh_port
    type    = "ssh"
    timeout = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 60 && cloud-init status --wait"
    ]
    on_failure = continue
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
    on_failure = continue
  }
}