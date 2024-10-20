resource "aws_vpc" "RESOURCE_VPC" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = var.vpc
  }
}

resource "aws_subnet" "RESOURCE_PUB_SUBNET" {
  vpc_id     = aws_vpc.RESOURCE_VPC.id
  count = var.number
  cidr_block = cidrsubnet(aws_vpc.RESOURCE_VPC.cidr_block, 8, count.index + 1)
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "RESOURCE_PRI_SUBNET" {
  vpc_id     = aws_vpc.RESOURCE_VPC.id
  count = var.number
  cidr_block = cidrsubnet(aws_vpc.RESOURCE_VPC, 8, count.index + 3 )
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "RESOURCE_IGW" {
  vpc_id = aws_vpc.RESOURCE_VPC.id

  tags = {
    Name = "Internet Gateway"
  }
}
