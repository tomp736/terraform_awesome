# cluster/outputs.tf

output "vm_info" {
  description = "vm info"
  value = {
    network_config = [
      for vm_network in local.vm_networks_data :
      {
        hostname = vm_network.hostname
        bridge   = vm_network.bridge
      }
    ]
    cloud_init_network_config = local.cloud_init_network_config
    cloud_init_user_data      = local.cloud_init_user_data
  }
}

output "ssh_info" {
  description = "ssh connection info"
  value = {
    type  = "ssh"
    agent = "true"
    host  = local.vm_fqdn
    port  = local.vm_global.ssh_port
    user  = local.vm_global.ssh_user
  }
  sensitive = true
}