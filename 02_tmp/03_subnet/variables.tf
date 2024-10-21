variable "vpc_id" {
  description = "vpc_id"
  type = string
  default = "vpc-05d0697c7c1b161fc"
}

variable "number" {
  description = "number"
  type = string
  default = "1"
}

variable "subnet" {
  description = "subnet"
  type = string
  default = "4"
}

variable "az" {
  description = "az"
  type = string
  default = "eu-central-1a"
}

variable "route_table" {
  description = "route_table"
  type = string
  default = "rtb-083365b57b330835e"
}

variable "name" {
  description = "name"
  type = string
  default = "vpc001"
}
