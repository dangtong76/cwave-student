#########################################################################################################
## IAM 계정 생성 (수강생)
#########################################################################################################
variable "iamusers" {
  type = list(string)
}

#########################################################################################################
## AWS CLI Profile 설정
#########################################################################################################

variable "terraform-aws-profile" {
  description = "AWS ACCESS ID AND KEY profile"
}

#########################################################################################################
## Terraform Workspace 설정
#########################################################################################################

variable "terraform-workspace-name" {
  description = "terraform workspace name"
}

#########################################################################################################
## IAC Provision 환경 변수 설정
#########################################################################################################

variable "env-prefix" {
  description = "Run Environment (dev-cwave | prod-cwave)"
  default     = "dev-cwave"
  type        = string
}


############################################################################################
## Terraform 버전 및 환경
############################################################################################
variable "terraform-version" {
  description = "Terraform version"
}

variable "terraform-aws-version" {
  description = "Version of terraform-aws-modules/vpc/aws"
}

############################################################################################≠/
## Region 및 Availability Zone(AZ) 설정
############################################################################################

variable "region" {
  description = "AWS Region Name"
}

variable "availability-zones" {
  description = "AZs in this region to use"
}

############################################################################################
## VPC & CIDR 설정
############################################################################################
variable "cwave-vpc-name" {
  description = "VPC Name of EKS"
}

variable "cwave-vpc-cidr" {
  description = "cidr of EKS VPC"
}

variable "cwave-vpc-igw-name" {
  description = "Name of Internet Gateway for EKS VPC"
}

############################################################################################
## CloudWave VPC Subnet 관련 변수 정의
############################################################################################

# Public 서브넷 CIDR
variable "subnet-cidrs-cwave-public" {
  description = "CWave Public Subnet CIDR"
}

# Private 서브넷 CIDR
variable "subnet-cidrs-cwave-private" {
  description = "CWave Private Subnet CIDR"
}


############################################################################################
## 기타 유틸리티
############################################################################################
# 수행 할때마다 변하지 않는 고정된 랜덤 스트링 사용시
resource "random_string" "suffix" {
  length  = 8
  special = false
}

# 수행 할때마다 변화되는 랜덤 스트링 사용시
resource "random_id" "rds_suffix" {
  byte_length = 8
}

############################################################################################
## Bastion 관련 설정
############################################################################################
variable "allow-ip-cidr-to-bastion" {
  description = "My Home Public IP Address"
}

variable "cwave-vpc-id" {
  description = "VPC id of EKS"
}

