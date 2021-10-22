# tfcb-iks-fso-bookinfo
Bookinfo FSO Demo Application running on IKS

Terraform Modules
- IKS
  - Build IKS cluster
- Kubernetes
  - Create Namespaces
    - Bookinfo
    - IWO
    - AppD
- Helm
  - Deploy Bookinfo App
  - Deploy IWO
    - Claim IWO?
    - Kubectl ??  Exec  commands?
  - Deploy AppD Cluster Agent
- Intersight
  - Claim IWO/Kubernetes Target
- AppD?
  - Health rule
  - Action
  - Policy
- TE
  - Create Internal Test?
  - Create Public Test?
    - CPOC DMZ 1:1 NAT?


? Load generator?
