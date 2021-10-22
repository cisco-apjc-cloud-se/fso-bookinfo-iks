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
    use_existing         = false
    create_new           = false
  }

  # # tr_policy_name = "test"
  # tr_policy = {
  #   use_existing = true
  #   name = "triggermesh-trusted-registry"
  # }

  runtime_policy = {
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
