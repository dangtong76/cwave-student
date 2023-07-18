############################################################################################
## 로드밸런서 콘트롤러 설정
## EKS 에서 Ingress 를 사용하기 위해서는 반듯이 로드밸런서 콘트롤러를 설정 해야함.
## 참고 URL : https://docs.aws.amazon.com/ko_kr/eks/latest/userguide/aws-load-balancer-controller.html
############################################################################################

######################################################################################################################
# 로컬변수
# 쿠버네티스 추가 될때마다 lb_controller_iam_role_name 을 추가해야함.
######################################################################################################################

locals {
  # Cwave EKS를 위한 role name
  cwave_eks_lb_controller_iam_role_name = "cwave-eks-aws-lb-controller-role-cwave01"
  k8s_aws_lb_service_account_namespace  = "kube-system"
  lb_controller_service_account_name    = "aws-load-balancer-controller"
}

# # Kubernetes 접속 정보 설정
# data "aws_eks_cluster_auth" "cwave-eks-auth" {
#   name = var.cwave-cluster-name
# }

module "cwave_eks_lb_controller_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version     = "v5.27.0"
  create_role = true

  role_name                     = local.cwave_eks_lb_controller_iam_role_name
  role_path                     = "/"
  role_description              = "Used by AWS Load Balancer Controller for EKS"
  role_permissions_boundary_arn = ""

  provider_url = replace(module.cwave-eks.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${local.k8s_aws_lb_service_account_namespace}:${local.lb_controller_service_account_name}"
  ]
  oidc_fully_qualified_audiences = [
    "sts.amazonaws.com"
  ]
}

######################################################################################################################
# IAM Policy 설정
######################################################################################################################
data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.0/docs/install/iam_policy.json"
}

data "local_file" "input" {
  filename = "policy/iam_policy.json"
}

resource "aws_iam_role_policy" "cwave-eks-controller" {
  name_prefix = "AWSLoadBalancerControllerIAMPolicy"
  role        = module.cwave_eks_lb_controller_role.iam_role_name
  #policy      = file(policy/iam_policy.json)
  policy = data.local_file.input.content
}

######################################################################################################################
# 헬름차트 변수 설정
# 쿠버네티스 클러스터가 추가 될때마다 set block 을 추가 해주기
######################################################################################################################
resource "helm_release" "release" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"

  dynamic "set" {
    for_each = {
      "clusterName"                                               = var.cwave-cluster-name
      "serviceAccount.create"                                     = "true"
      "serviceAccount.name"                                       = local.lb_controller_service_account_name
      "region"                                                    = var.region
      "vpcId"                                                     = data.aws_vpc.cwave-vpc.id
      "image.repository"                                          = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.cwave_eks_lb_controller_role.iam_role_arn
    }

    content {
      name  = set.key
      value = set.value
    }
  }
}