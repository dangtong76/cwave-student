data "aws_subnets" "subnet-cwave-private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cwave-vpc.id]
  }
  tags = {
    Name = "*PRIVATE*"
  }
}

output "test" {
  value = data.aws_subnets.subnet-cwave-private.ids
}