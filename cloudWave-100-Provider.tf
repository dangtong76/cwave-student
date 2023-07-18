provider "aws" {
  region = var.region
  profile = var.terraform-aws-profile
}

# Kubernetes 접속 정보 설정
data "aws_eks_cluster" "cwave-cluster" {
  name = module.cwave-eks.cluster_id
}

data "aws_eks_cluster_auth" "cwave-eks-auth" {
  name = module.cwave-eks.cluster_id
}

provider "kubernetes" {
  alias = "cwave-eks"
  host                   = data.aws_eks_cluster.cwave-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cwave-eks-auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cwave-cluster.certificate_authority.0.data)
  # load_config_file       = false
}

provider "helm" {
  alias = "cwave-eks-helm"
  kubernetes {
    host                   = module.cwave-eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cwave-eks-auth.token
    cluster_ca_certificate = base64decode(module.cwave-eks.cluster_certificate_authority_data)
    # load_config_file       = false
  }
}