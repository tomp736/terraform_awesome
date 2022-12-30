# ./main.tf

module "cloud_init_configs" {
  for_each = var.nodes
  source   = "../../cloud-init"

  general = {
    hostname                   = each.value.name
    package_reboot_if_required = true
    package_update             = true
    package_upgrade            = true
    timezone                   = "Europe/Warsaw"
  }
  users_data = [
    {
      name                = "${var.sshd_config.ssh_user}"
      shell               = "/bin/bash"
      ssh-authorized-keys = var.public_keys
    }
  ]
  runcmd = [
    "mkdir -p /etc/ssh/sshd_config.d",
    "echo \"Port ${var.sshd_config.ssh_port}\" > /etc/ssh/sshd_config.d/90-defaults.conf"
  ]
}

module "nodes" {
  for_each = var.nodes
  source   = "../node"

  node_config = each.value
  networks = [
    for network in var.nodes[each.value.id].networks : {
      name       = network.id
      network_id = var.networks_map[network.id].hetzner_id
      ip         = network.ip == "" ? null : network.ip
    }
  ]
  cloud_init_user_data = module.cloud_init_configs[each.key].user_data
}

resource "null_resource" "cloud_init" {
  for_each = var.nodes
  depends_on = [
    module.nodes
  ]
  connection {
    host         = var.bastion_host == null ? module.nodes[each.value.id].ipv4_address : module.nodes[each.value.id].networks[var.networks_map["bnet"].hetzner_id].ip
    bastion_host = var.bastion_host
    agent        = true
    user         = var.sshd_config.ssh_user
    port         = var.sshd_config.ssh_port
    type         = "ssh"
    timeout      = "5m"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 5 && cloud-init status --wait"
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

resource "null_resource" "udev_network_interfaces" {
  for_each = var.nodes

  depends_on = [
    null_resource.cloud_init
  ]

  connection {
    host         = var.bastion_host == null ? module.nodes[each.value.id].ipv4_address : module.nodes[each.value.id].networks[var.networks_map["bnet"].hetzner_id].ip
    bastion_host = var.bastion_host
    agent        = true
    user         = var.sshd_config.ssh_user
    port         = var.sshd_config.ssh_port
    type         = "ssh"
    timeout      = "5m"
  }

  triggers = {
    networks = md5(templatefile("${path.module}/templates/70-persistent-net.tftpl", {
      interfaces = [for network in each.value.networks : {
        name        = network.id
        mac_address = module.nodes[each.value.id].networks[var.networks_map[network.id].hetzner_id].mac_address
      }]
    }))
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/70-persistent-net.tftpl", {
      interfaces = [for network in each.value.networks : {
        name        = network.id
        mac_address = module.nodes[each.value.id].networks[var.networks_map[network.id].hetzner_id].mac_address
      }]
    })
    destination = "/tmp/70-persistent-net.rules"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp -f /tmp/70-persistent-net.rules /etc/udev/rules.d/70-persistent-net.rules",
      "sudo chmod 644 /etc/udev/rules.d/70-persistent-net.rules",
      "sudo udevadm control --reload-rules",
      "sudo udevadm trigger --attr-match=subsystem=net",
      "sudo shutdown -r now"
    ]
    on_failure = continue
  }
}