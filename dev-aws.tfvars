# AWS Profile (AWS Credential 의 profile 명과 일치 해야함)
terraform-aws-profile    = "cwave-student"
terraform-workspace-name = "cwave01"

# PREFIX , Region, AZ
env-prefix = "dev-cwave01"

# AWS IAM 유저 목록
iamusers = [
  "cwave01", "cwave02", "cwave03", "cwave04", "cwave05", "cwave06", "cwave07", "cwave08", "cwave09", "cwave010",
  "cwave11", "cwave12", "cwave13", "cwave14", "cwave15", "cwave16", "cwave17", "cwave18", "cwave19", "cwave020",
  "cwave21", "cwave22", "cwave23", "cwave24", "cwave25", "cwave26", "cwave27"
]

# terraform and module Version
terraform-version     = "1.1.9"
terraform-aws-version = "3.2.0"

# Region and AZ
region = "ap-northeast-2"
# availability-zones = ["ap-northeast-2a","ap-northeast-2b","ap-northeast-2c","ap-northeast-2d"]
availability-zones = ["ap-northeast-2a", "ap-northeast-2b"]

# VPC and IGW
cwave-vpc-name     = "CWAVE-VPC (10.113.0.0/16)"
cwave-vpc-cidr     = "10.113.0.0/16"
cwave-vpc-igw-name = "CWAVE-VPC-IGW"

# Public, Private, Database 3개 서브넷에 대한 설정
subnet-cidrs-cwave-public  = ["10.113.0.0/20", "10.113.16.0/20"]
subnet-cidrs-cwave-private = ["10.113.80.0/20", "10.113.96.0/20"]


# EKS Config
cwave-cluster-name                  = "cwave01-eks"
cwave-cluster-version               = "1.27"
cwave-eks-basic-instance-type-green = ["t3.large"]
cwave-eks-basic-instance-type-blue  = ["t3.large"]
cwave-eks-min-size                  = 3
cwave-eks-max-size                  = 4
cwave-eks-desired_size              = 3


# Bastion ACCESS 관련 설정
allow-ip-cidr-to-bastion = ["61.75.81.175/32"]

# VPC ID
cwave-vpc-id = "vpc-02aa2612237582ee1"