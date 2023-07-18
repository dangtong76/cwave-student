# Variables for EKS

variable "cwave-cluster-name" {
  description = "AWS kubernetes cluster name"
}

variable "cwave-cluster-version" {
  description = "AWS EKS supported Cluster Version to current use"
}


variable "cwave-eks-enabled-log-types" {
  type        = list(string)
  description = "log type of EKS control plane (api, audit, authenticator, controllerManager, scheduler)"
  default     = []
}

variable "cwave-eks-basic-instance-type-green" {
  description = "eks basic ec2 instance type"
}
variable "cwave-eks-basic-instance-type-blue" {
  description = "eks basic ec2 instance type"
}


variable "cwave-eks-min-size" {
  description = "minimum count of ec2 node in eks"
}
variable "cwave-eks-max-size" {
  description = "maximum count of ec2 node in eks"
}
variable "cwave-eks-desired_size" {
  description = "desired count of ec2 node in eks"
}