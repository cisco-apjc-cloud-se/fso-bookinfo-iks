### Helm Provider ###
# - Use Kube_config from IKS Module


// provider "kubernetes" {
//   config_path = var.config_path
//   // host                   = data.aws_eks_cluster.vault.endpoint
//   // cluster_ca_certificate = base64decode(data.aws_eks_cluster.vault.certificate_authority.0.data)
//   // token                  = data.aws_eks_cluster_auth.vault.token
//   // # load_config_file       = false
//   // # version                = "~> 1.11"
// }
//
//
// provider "helm" {
//   kubernetes {
//     config_path = var.config_path
//   //   # config_path = "~/.kube/config"
//   //   host                   = var.host
//   //   cluster_ca_certificate = var.cluster_ca_certificate
//   //   token                  = var.token
//   }
// }


## Add new namespace
# - provider implict
// resource "kubernetes_namespace" "vault" {
//   metadata {
//     annotations = {
//       name = "vault"
//     }
//
//     # labels = {
//     #   app = "vault"
//     # }
//
//     name = "vault"
//   }
// }

resource "kubernetes_namespace" "iwo-collector" {
  metadata {
    annotations = {
      name = "iwo-collector"
    }
    name = "iwo-collector"
  }
}

## Build Application ##
# - Consul for storage backend
# - Vault

// resource "helm_release" "consul" {
//   namespace   = kubernetes_namespace.vault.metadata[0].name
//   name        = "consul"
//
//   repository  = "https://helm.releases.hashicorp.com"
//   chart       = "consul"
//
//   set {
//     name  = "global.name"
//     value = "consul"
//   }
//
//   set {
//     name  = "global.datacenter"
//     value = "vault"
//   }
//
//   // set {
//   //   name  = "client.enabled"
//   //   value = true
//   // }
//
//   // set {
//   //   name  = "server.replicas"
//   //   value = 1
//   // }
//
//   set {
//     name  = "ui.service.type"
//     value = "ClusterIP"
//   }
//
//
// }

 // resource "helm_release" "vault" {
 //   namespace   = kubernetes_namespace.vault.metadata[0].name
 //   name        = "vault"
 //
 //   repository  = "https://helm.releases.hashicorp.com"
 //   chart       = "vault"
 //
 //   values = [<<EOF
 //   global:
 //     tlsDisable: false
 //   server:
 //     extraEnvironmentVars:
 //       VAULT_CACERT: /vault/userconfig/vault-tls/vault.ca
 //     extraVolumes:
 //     - type: secret
 //       name: vault-tls
 //     ha:
 //       config: |
 //         listener "tcp" {
 //           ui = true
 //
 //           tls_disable = 0
 //           address = "[::]:8200"
 //           cluster_address = "[::]:8201"
 //           tls_cert_file = "/vault/userconfig/vault-tls/vault.crt"
 //           tls_key_file  = "/vault/userconfig/vault-tls/vault.key"
 //           tls_client_ca_file = "/vault/userconfig/vault-tls/vault.ca"
 //         }
 //         storage "consul" {
 //            path = "vault"
 //            address = "HOST_IP:8500"
 //         }
 //         service_registration "kubernetes" {}
 //   EOF
 //   ]
 //
 //   // set {
 //   //   name = "global.tlsDisable"
 //   //   value = false
 //   // }
 //
 //   set {
 //     name  = "server.service.type"
 //     value = "LoadBalancer"
 //   }
 //
 //   set {
 //     name  = "server.dataStorage.enabled"
 //     value = false
 //   }
 //
 //   set {
 //     name = "server.ha.enabled"
 //     value = true
 //   }
 //
 //   set {
 //     name  = "server.ha.replicas"
 //     value = 3
 //   }
 //
 //   // set {
 //   //   name  = "server.extraVolumes.type"
 //   //   value = "secret"
 //   // }
 //   //
 //   // set {
 //   //   name  = "server.extraVolumes.name"
 //   //   value = "vault-tls"
 //   // }
 //   //
 //   // set {
 //   //   name = "server.extraEnvironmentVars.VAULT_CACERT"
 //   //   value = "/vault/userconfig/vault-server-tls/vault.ca"
 //   // }
 //   //
 //   // set {
 //   //   name = "server.ha.config"
 //   //   value = "{ listener 'tcp' { address = '0.0.0.0:8200', tls_cert_file = '/vault/userconfig/vault-server-tls/vault.crt', tls_key_file  = '/vault/userconfig/vault-server-tls/vault.key', tls_client_ca_file = '/vault/userconfig/vault-server-tls/vault.ca'  }"
 //   // }
 //
 //   // set {
 //   //   name = "server.ha.config"
 //   //   value = 'storage "consul" { path = "vault" address = "HOST_IP:8500"}'
 //   // }
 //
 //   set {
 //     name = "ui.enabled"
 //     value = true
 //   }
 //
 //   // set {
 //   //   name = "ui.serviceType"
 //   //   value = "LoadBalancer"
 //   // }
 //
 // }

 resource "helm_release" "iwo-collector" {
   namespace   = kubernetes_namespace.iwo-collector.metadata[0].name
   name        = "iwo-collector"

   // repository  = "https://helm.releases.hashicorp.com"
   chart       = "https://iwo-k8s-collector.s3.ap-southeast-2.amazonaws.com/iwo-k8s-collector-v1.0.1.tar.gz"

   set {
     name  = "iwoServerVersion"
     value = "8.2"
   }

   set {
     name  = "collectorImage.tag"
     value = "8.2.1"
   }

   set {
     name  = "targetName"
     value = "iks-cpoc-bookinfo"
   }

 }
