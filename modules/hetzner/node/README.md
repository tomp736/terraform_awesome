# Terraform Hetzner Node

## Example usage

Define libvirt provider.

``` tf
# providers.tf
provider "hcloud" {
  token = var.hcloud_token
}
```

Define module to provision machines.

``` tf
# main.tf
module "vms" {
  source             = "git@github.com:labrats-work/modules-terraform.git//modules/hetzner/node"
  config_filepath    = "files/node_config.json"
}
```
