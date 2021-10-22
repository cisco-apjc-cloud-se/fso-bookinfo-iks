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
