
resource "aws_vpc" "vpc_multi" {
  count = var.number
  cidr_block = "1${count.index+1}.0.0.0/16"
  tags = {
    Name = "${var.name}-${count.index+1}"
  }
}
