
data "aws_vpc" "vpc_data_pri" {
  id = var.vpc_id
}

resource "aws_subnet" "pri_sn" {
  vpc_id     = data.aws_vpc.vpc_data_pri.id
  count = var.number2
  cidr_block = cidrsubnet(data.aws_vpc.vpc_data_pri.cidr_block, 8, count.index + var.subnet)
  availability_zone = var.az

  tags = {
    Name = " private ${var.name}-${count.index+1}"
  }
}

resource "aws_eip" "eip_pri" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_pri" {
  subnet_id     = element(aws_subnet.pri_sn[*].id, 0)
  allocation_id = aws_eip.eip_pri.id

  tags = {
    Name = "Nat Gateway ${var.name}"  
  }
}

resource "aws_route_table" "rt_pri" {
  vpc_id = data.aws_vpc.vpc_data_pri.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_pri.id
  }

  tags = {
    Name = "Route Table Private ${var.name}"
  }
}

resource "aws_route_table_association" "autoscaling_01_ass_private" {
  route_table_id = aws_route_table.rt_pri.id
  count = var.number2
  subnet_id      = element(aws_subnet.pri_sn[*].id, count.index)
}
