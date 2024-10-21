resource "aws_vpc" "vpc_multi" {
  count = var.number
  cidr_block = "1${count.index+1}.0.0.0/16"
  tags = {
    Name = "${var.name}-${count.index+1}"
  }
}

resource "aws_internet_gateway" "vpc_multi_igw" {
  count = var.number
  vpc_id = aws_vpc.vpc_multi[count.index].id

  tags = {
    Name = "Internet Gateway ${var.name} ${count.index}"
  }
}

resource "aws_route_table" "vpc_multi_rt" {
  count = var.number
  vpc_id = aws_vpc.vpc_multi[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_multi_igw[count.index].id
  }

  tags = {
    Name = "Route Table Public ${var.name} ${count.index}"
  }
}
