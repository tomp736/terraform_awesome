# cluster/provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

[default]
aws_region = YOUR_AWS_ACCESS_KEY_ID
aws_access_key_id = YOUR_AWS_ACCESS_KEY_ID
aws_secret_access_key = YOUR_AWS_SECRET_ACCESS_KEY