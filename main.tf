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
    helm = {
      source = "hashicorp/helm"
      # version = "2.0.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
//
// ### Define Kube Config as Local ###
// locals {
//   kube_config = data.intersight_kubernetes_cluster.iks.results[0].kube_config
// }

### Providers ###
provider "intersight" {
  # Configuration options
  apikey    = var.intersight_key
  secretkey = var.intersight_secret
  endpoint =  var.intersight_url
}

// provider "kubernetes" {
//   config_path = data.intersight_kubernetes_cluster.iks.results[0].kube_config
// }
//
//
// provider "helm" {
//   kubernetes {
//     config_path = data.intersight_kubernetes_cluster.iks.results[0].kube_config
//   }
// }


### Intersight Organization ###
data "intersight_organization_organization" "org" {
  name = var.org_name
}


## See the following additional Terraform modules
# - IKS
#   Deploys new Intersight Kubernetes Service (IKS) cluster for on-premise K8S
# - Helm (and Kubernetes)
#   - Creates IWO namespace & deploys IWO release


## IKS Module ##
module "terraform-intersight-iks" {
  source = "terraform-cisco-modules/iks/intersight//"

  ip_pool = {
    use_existing = true
    name = "iks-cpoc-ip"
    # ip_starting_address = "10.139.120.220"
    # ip_pool_size        = "20"
    # ip_netmask          = "255.255.255.0"
    # ip_gateway          = "10.139.120.1"
    # dns_servers         = ["10.101.128.15"]
  }

  sysconfig = {
    use_existing = true
    name = "grscarle-iks-cpoc-1-sys-config-policy"
    # domain_name = "rich.ciscolabs.com"
    # timezone    = "America/New_York"
    # ntp_servers = ["10.101.128.15"]
    # dns_servers = ["10.101.128.15"]
  }

  k8s_network = {
    use_existing = false
    name = "default"
    ######### Below are the default settings.  Change if needed. #########
    pod_cidr = "100.65.0.0/16"
    service_cidr = "100.64.0.0/24"
    cni = "Calico"
  }

  # Version policy
  version_policy = {
    use_existing = true
    name = "k8s-1.19"
    # version = "1.19.5"
  }

  tr_policy = {
    ### Needs to be set with "use_existing" & "create_new" as false to not deploy a Trusted Registry Policy
    use_existing         = false
    create_new           = false
  }

  # # tr_policy_name = "test"
  # tr_policy = {
  #   use_existing = true
  #   name = "triggermesh-trusted-registry"
  # }

  runtime_policy = {
    ### Needs to be set with "use_existing" & "create_new" as false to not deploy a Runtime Policy
    use_existing         = false
    create_new           = false
  }
  # runtime_policy = {
  #   use_existing = true
  #   name = "runtime"
  #   http_proxy_hostname = "proxy.com"
  #   http_proxy_port = 80
  #   http_proxy_protocol = "http"
  #   http_proxy_username = null
  #   http_proxy_password = null
  #   https_proxy_hostname = "proxy.com"
  #   https_proxy_port = 8080
  #   https_proxy_protocol = "https"
  #   https_proxy_username = null
  #   https_proxy_password = null
  # }

  # Infra Config Policy Information
  infra_config_policy = {
    use_existing = true
    name = "cpoc-hx"
    # vc_target_name = "marvel-vcsa.rich.ciscolabs.com"
    # vc_portgroups    = ["panther|iks|tme"]
    # vc_datastore     = "iks"
    # vc_cluster       = "tchalla"
    # vc_resource_pool = ""
    # vc_password      = var.vc_password
  }

  addons_list = [
    # {
    # addon_policy_name = "dashboard"
    # addon             = "kubernetes-dashboard"
    # description       = "K8s Dashboard Policy"
    # upgrade_strategy  = "AlwaysReinstall"
    # install_strategy  = "InstallOnly"
    # },
    # {
    #   addon_policy_name = "monitor"
    #   addon             = "ccp-monitor"
    #   description       = "Grafana Policy"
    #   upgrade_strategy  = "AlwaysReinstall"
    #   install_strategy  = "InstallOnly"
    # }
  ]

  instance_type = {
    use_existing = true
    name = "rw-iks-vm-type"
    # cpu = 4
    # memory = 16386
    # disk_size = 40
  }

  # Cluster information
  cluster = {
    name = "tfcb-cpoc-iks-1"
    action = "Deploy" # Unassign, Deploy
    wait_for_completion = true
    worker_nodes = 3
    load_balancers = 5
    worker_max = 4
    control_nodes = 1
    ssh_user        = var.ssh_user
    ssh_public_key  = var.ssh_key
  }

  # Organization and Tag
  organization = var.org_name
  tags         = var.tags

}

### Read Target IKS Cluster Details ###
data "intersight_kubernetes_cluster" "iks" {
  moid = module.terraform-intersight-iks.cluster_moid
}


// ### Helm Module ###
// module "helm" {
//   source = "./modules/helm"
//
//   // config_path = data.intersight_kubernetes_cluster.iks.results[0].kube_config
//   // host                   = data.aws_eks_cluster.vault.endpoint
//   // cluster_ca_certificate = base64decode(data.aws_eks_cluster.vault.certificate_authority.0.data)
//   // token                  = data.aws_eks_cluster_auth.vault.token
//
//   depends_on = [module.terraform-intersight-iks]
//
// }
