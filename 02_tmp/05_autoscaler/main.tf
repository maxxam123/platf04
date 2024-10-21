
### Internet -> ALB

resource "aws_security_group" "alb_sg" {
  name        = var.sg_lb_name
  description = "alb_sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "alb_sg ${var.sg_lb_name}"
  }
}

resource "aws_lb" "app_lb" {
  name               = var.lb_name
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.autoscaling_01_subnet_public[*].id
  ############### subnets            = [aws_subnet.autoscaling_01_subnet_public[*].id]
  depends_on = [ aws_internet_gateway.autoscaling_01_igw ]
}

resource "aws_lb_target_group" "alb_ec2_tg" {
  name     = var.lb_target_group_name
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.vpc.id

  tags = {
    name = "alb_ec2_tg ${var.lb_target_group_name}"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ec2_tg.arn
  }

  tags = {
    name = "alb_ec2_tg ${var.lb_target_group_name}"
  }
}

###  ALB -> EC2

resource "aws_security_group" "ec2_sg" {
  name        = var.ec2_sg_name
  description = "ec2_sg"
  vpc_id      = aws_vpc.autoscaling_01_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "ec2_sg"
  }
}

resource "aws_launch_template" "ec2_launch_template" {
  name = var.launch_template_name
  
  image_id = var.image
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [ aws_security_group.ec2_sg ]
  }

  user_data = filebase64(("userdata.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      name = "ec2_launch_template ${var.launch_template_name}"
    }
  }
}

resource "aws_autoscaling_group" "ec2_asg" {
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  name                      = var.autoscaling_group_name
  target_group_arns = [ aws_lb_target_group.alb_ec2_tg.arn ]
  vpc_zone_identifier       = [aws_subnet.autoscaling_01_subnet_private[*].id]
  
  launch_template {
    id = aws_launch_template.ec2_launch_template.id
    version = "$Laname"
  }

  health_check_type = "EC2"
}

output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
}
