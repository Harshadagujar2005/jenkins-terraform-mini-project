variable "container_name" {
  type = string
}

variable "image" {
  type = string
}

variable "internal_port" {
  type    = number
  default = 3000
}

variable "external_port" {
  type = number
}

variable "environment" {
  type    = string
  default = "dev"
}
