# Terraform KVM Node

## Example usage

Define libvirt uri.

``` tf
# providers.tf
provider "libvirt" {
  uri = "{{uri}}"
}
```

Define module to create VM's

``` tf
# main.tf
module "node" {
  source             = "git@github.com:labrats-work/modules-terraform.git//modules/kvm/node"
  config_filepath    = "files/node_config.json"
}
```
