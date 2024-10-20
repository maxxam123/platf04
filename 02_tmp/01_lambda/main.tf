
resource "aws_instance" "EC2" {
 ami = "ami-03a115bbd6928e698"
 instance_type = "t2.micro"
 count = var.number
 
 tags = {
  Name = "Instance ${count.index+1}"
 }
}
