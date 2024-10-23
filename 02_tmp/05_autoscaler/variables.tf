variable "name" {
  description = "name"
  type = string
  default = "autoscaler100"
}

variable "vpc_id" {
  type        = "string"
  default     = ""
}

variable "sg_lb_name" {
  type        = "string"
  default     = "sg_lb_01"
}

variable "subnets" {
  type        = list(string)
  default = ["","",""]
}

variable "lb_name" {
  type        = "string"
  default     = "lb_01"
}

variable "lb_target_group_name" {
  type        = "string"
  default     = "lb_target_group_01"
}


variable "lb_target_group" {
  type        = "string"
  default     = "lb_target_group_01"
}

variable "ec2_sg_name" {
  type        = "string"
  default     = "ec2_sg_01"
}

variable "launch_template_name" {
  type        = "string"
  default     = "launch_template_01"
}

variable "image" {
  type        = "string"
  default     = "ami-08ec94f928cf25a9d"
}

variable "instance_type" {
  type        = "string"
  default     = "t2.micro"
}

variable "max_size" {
  type        = "string"
  default     = "3"
}

variable "min_size" {
  type        = "string"
  default     = "2"
}

variable "desired_capacity" {
  type        = "string"
  default     = "3"
}

variable "autoscaling_group_name" {
  type        = "string"
  default     = "autoscaling_group_01"
}
