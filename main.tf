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

provider "intersight" {
  # Configuration options
  apikey    = var.intersight_key
  secretkey = var.intersight_secret
  endpoint =  var.intersight_url
}

### Organization ###
data "intersight_organization_organization" "org" {
  name = var.org_name
}

# ## Intersight Module
# module "intersight" {
#   source = "./modules/intersight"
#
#   intersight_key    = var.intersight_key
#   intersight_secret = var.intersight_secret
#   intersight_url    = var.intersight_url
#   org_name          = var.org_name
#
# }
