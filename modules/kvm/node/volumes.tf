resource "libvirt_volume" "volume_root" {
  name = "${local.vm_global.volume_name_prefix}${local.vm_global.name}_${local.vm_disks_data["root"].name}"
  pool = local.vm_disks_data["root"].pool

  base_volume_name = local.vm_disks_data["root"].base_volume_name
  base_volume_pool = try(local.vm_disks_data["root"].base_volume_pool, local.vm_disks_data["root"].pool)
  format           = local.vm_disks_data["root"].format
  size             = local.vm_disks_data["root"].size
}

resource "libvirt_volume" "volume_data" {
  for_each = { for disk in local.vm_disks_data : disk.name => disk if(disk.name != "root") }

  name = "${local.vm_global.volume_name_prefix}${local.vm_global.name}_${each.value.name}"
  pool = each.value.pool

  base_volume_name = each.value.base_volume_name
  format           = each.value.format
  size             = each.value.size
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "${local.vm_global.volume_name_prefix}${local.vm_global.name}_cloud_init.iso"
  pool = local.vm_global.cloud_init_pool

  user_data      = "#cloud-config\n${local.cloud_init_user_data}"
  network_config = local.cloud_init_network_config
  meta_data      = local.cloud_init_metadata
}
