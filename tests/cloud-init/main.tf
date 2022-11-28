# ./main.tf

module "cloud_init" {
  source = "../../modules/cloud-init"

  general = {
    hostname = "default"
  }
  runcmd = [     
    "mkdir -p /etc/ssh/sshd_config.d",
    "echo \"Port 2222\" > /etc/ssh/sshd_config.d/90-defaults.conf",
    "semanage port -a -t ssh_port_t -p tcp 2222"
   ]
}

resource "local_file" "user_data" {
  content  = <<-EOT
${module.cloud_init.user_data}
  EOT
  filename = "user_data"  
}

resource "local_file" "metadata" {
  content  = <<-EOT
${module.cloud_init.metadata}
  EOT
  filename = "metadata"  
}

resource "local_file" "network_config" {
  content  = <<-EOT
${module.cloud_init.network_config}
  EOT
  filename = "network_config"  
}