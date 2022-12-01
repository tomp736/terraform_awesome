# providers.tf

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  shared_config_files      = ["~/.aws/conf"]
  shared_credentials_files = ["~/.aws/creds"]
  profile                  = "default"
}