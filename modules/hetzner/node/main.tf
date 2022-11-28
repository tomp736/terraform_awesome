resource "hcloud_server" "node" {
  # hetzner
  name        = local.hetzner.name
  location    = local.hetzner.location
  image       = local.hetzner.image
  server_type = local.hetzner.server_type

  # cloud-init
  user_data = "#cloud-config\n${var.cloud_init_user_data}"

  labels = {
    nodetype = local.hetzner.nodetype
  }
}

resource "null_resource" "cloud-init" {
  depends_on = [
    hcloud_server.node
  ]

  connection {
    host    = hcloud_server.node.ipv4_address
    agent   = true
    user    = local.hetzner.ssh_user
    port    = local.hetzner.ssh_port
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