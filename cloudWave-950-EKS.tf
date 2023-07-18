module "cwave-eks" {
  source                                 = "terraform-aws-modules/eks/aws"
  version                                = "~> 18.2"
  cluster_name                           = var.cwave-cluster-name
  cluster_version                        = var.cwave-cluster-version
  vpc_id                                 = data.aws_vpc.cwave-vpc.id
  subnet_ids                             = data.aws_subnets.subnet-cwave-private.ids
  cloudwatch_log_group_retention_in_days = 1
  cluster_enabled_log_types              = ["api", "authenticator", "audit", "scheduler", "controllerManager"]

  ## Public Private EndPoint Access Policy
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  ## Cluster Encryption
  create_kms_key = true
  cluster_encryption_config = [{
    resources = ["secrets"]
  }]
  kms_key_description           = "KMS Secrets encryption for CWave EKS cluster."
  kms_key_enable_default_policy = true

  ## Cluster Addons
  cluster_addons = {
    coredns = {
      #resolve_conflicts = "OVERWRITE"
    }

    kube-proxy = {}
    vpc-cni = {
      cluster_name = var.cwave-cluster-name
      #resolve_conflicts = "OVERWRITE"
    }
  }

  eks_managed_node_groups = {
    green = {
      disk_size      = 500
      min_size       = 3
      max_size       = 5
      desired_size   = 3
      instance_types = var.cwave-eks-basic-instance-type-green
      delete         = true
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
      tags = {
        Environment = var.cwave-cluster-name
        Terraform   = "true"
      }
    }
  }

  ## Cluster Security Group
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ### Allow All Port Between Node
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ### Allow All Port Between Cluster 
    ingress_cluster_all = {
      description                   = "Cluster to node all ports/protocols"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

data "aws_ami" "cwave_eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cwave-cluster-version}-v*"]
  }
}

resource "tls_private_key" "cwave-eks-tls-key" {
  algorithm = "RSA"
}

module "vpc_cni_irsa_cwave_eks" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 4.12"

  role_name_prefix      = "VPC-CNI-IRSA-CWAVE"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.cwave-eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}
