terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mel-ciscolabs-com"
    workspaces {
      name = "tfcb-iks-fso-bookinfo"
    }
  }
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      # version = "1.0.12"
    }
  }
}

## Intersight Module
module "intersight" {
  source = "./modules/intersight"

  intersight_key    = var.intersight_key
  intersight_secret = var.intersight_secret
  intersight_url    = var.intersight_url
  org_name          = var.org_name

}
