data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = [
      var.node_config.image
    ]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "node" {
  # aws
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.node_config.instance_type

  # cloud-init
  user_data = "#cloud-config\n${var.cloud_init_user_data}"

  dynamic "network_interface" {
    for_each = var.network_interface_config
    content {
      network_interface_id = network_interface.network_interface_id
      device_index         = network_interface.device_index
    }
  }

  tags = {
    nodetype = var.node_config.nodetype
  }
}

resource "null_resource" "cloud-init" {
  depends_on = [
    aws_instance.node
  ]

  connection {
    host    = aws_instance.node.public_ip
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