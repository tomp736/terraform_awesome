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

resource "aws_network_interface" "net0" {
  subnet_id = var.subnet_id

  tags = {
    name = var.node_config.name
  }
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.net0
}

resource "aws_instance" "node" {
  # aws
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.node_config.instance_type

  # cloud-init
  user_data = "#cloud-config\n${var.cloud_init_user_data}"

  network_interface {
    network_interface_id = aws_network_interface.net0.id
    device_index         = 0
  }

  tags = {
    name     = var.node_config.name
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