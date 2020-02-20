variable "name" {
  default = "fake-product-staging"
}

variable "environment_name" {
  default = "staging"
}

variable "private_subnets" {
  default = "172.19.12.0/22,172.19.16.0/22,172.19.20.0/22"
}

variable "public_subnets" {
  default = "172.19.0.0/22,172.19.4.0/22,172.19.8.0/22"
}

variable "cidr_range" {
  default = "172.19.0.0/19"
}

variable "availability_zones" {
  default = "eu-west-1a,eu-west-1b,eu-west-1c"
}
