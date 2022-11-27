# Terraform KVM Node

## Example usage

Define libvirt uri.

``` tf
# providers.tf
provider "libvirt" {
  uri = ""
}
```

Define module to create VM's

``` tf
# main.tf
module "vms" {
  source             = "git@github:labrats/infrastructure/terraform/modules.kvm.git//modules/kvm/node"
  vm_config_filepath = each.value.vm_config_filepath
}
```

Define locals to drive configuration.

``` tf
# main.tf
locals {
  nodes = [
    {
      id              = "c0m0",
      config_filepath = "${path.module}/files/c0m0_config.json"
    },
    {
      id              = "c0w0",
      config_filepath = "${path.module}/files/c0w0_config.json"
    }
  ]
}fig_filepath = each.value.vm_config_filepath
}
```
