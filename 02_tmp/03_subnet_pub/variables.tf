variable "name" {
  description = "name"
  type = string
  default = "subnet_pub100"
}

variable "vpc_id" {
  description = "vpc_id"
  type = string
  default = ""
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
  default = ""
}

variable "name" {
  description = "name"
  type = string
  default = "subnet_default"
}
