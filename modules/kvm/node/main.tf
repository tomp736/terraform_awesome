resource "libvirt_domain" "vm_node" {
  name        = local.vm_global.name
  description = local.vm_global.description
  memory      = local.vm_memory
  vcpu        = local.vm_cpus
  autostart   = local.vm_autostart

  cpu {
    mode = local.vm_cpu_mode
  }

  dynamic "network_interface" {
    for_each = local.vm_networks_data
    content {
      bridge         = network_interface.value.bridge
      hostname       = network_interface.value.hostname
      mac            = network_interface.value.mac
      wait_for_lease = network_interface.value.wait_for_lease
    }
  }

  dynamic "disk" {
    for_each = concat(
      [
        {
          volume_id    = libvirt_volume.volume_root.id
          scsi         = "false"
          block_device = ""
          file         = ""
          url          = ""
          wwn          = ""
        }
      ],
      [
        for vm_volume in libvirt_volume.volume_data :
        {
          volume_id    = vm_volume.id
          scsi         = "false"
          block_device = ""
          file         = ""
          url          = ""
          wwn          = ""
        }
    ])
    content {
      volume_id    = disk.value.volume_id
      scsi         = disk.value.scsi
      block_device = disk.value.block_device
      file         = disk.value.file
      url          = disk.value.url
      wwn          = disk.value.wwn
    }
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  boot_device {
    dev = ["hd", "network"]
  }

  connection {
    type  = "ssh"
    agent = "true"
    host  = local.vm_fqdn
    port  = local.vm_global.ssh_port
    user  = local.vm_global.ssh_user
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo reboot now"
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
