variable "number" {
  description = "number"
  type = string
  default = "1"
}

variable "name" {
  description = "name"
  type = string
  default = "vpc001"
}

variable "vpc_id" {
  description = "vpc_id"
  type = string
  default = ""
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

variable "number2" {
  description = "number2"
  type = string
  default = "2"
}
