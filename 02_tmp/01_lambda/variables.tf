variable "name" {
  description = "name"
  type = string
  default = "lmabda100"
}

variable "function" {
  description = "function"
  type = string
  default = "aws200"
}

variable "role" {
  description = "role"
  type = string
}

variable "runtime" {
  description = "runtime"
  type = string
}

variable "gateway" {
  description = "gateway"
  type = string
}

variable "path" {
  description = "path"
  type = string
}
