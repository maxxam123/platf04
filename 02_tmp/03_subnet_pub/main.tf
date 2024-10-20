
data "aws_vpc" "vpc_data" {
  id = var.vpc_id
}

resource "aws_subnet" "pub_sn_multi" {
  vpc_id     = data.aws_vpc.vpc_data.id
  count = var.number
  cidr_block = cidrsubnet(data.aws_vpc.vpc_data.cidr_block, 8, count.index + var.subnet)
  availability_zone = var.az

  tags = {
    Name = "public ${var.name}-${count.index+1}"
  }
}

resource "aws_route_table_association" "autoscaling_01_ass_public" {
  route_table_id = var.route_table
  count = var.number
  subnet_id      = element(aws_subnet.pub_sn_multi[*].id, count.index)
}
