# Terraform Hetzner Node

## Example usage

Define hcloud provider.

``` tf
# providers.tf
provider "hcloud" {
  token = {{token}}
}
```

Define module to provision machines.

``` tf
# main.tf
module "node" {
  source             = "git@github.com:labrats-work/modules-terraform.git//modules/hetzner/node"
  config_filepath    = "files/node_config.json"
}
```
