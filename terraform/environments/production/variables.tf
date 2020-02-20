variable "name" {
  default = "fake-product-production"
}

variable "environment_name" {
  default = "production"
}

variable "private_subnets" {
  default = "172.18.12.0/22,172.18.16.0/22,172.18.20.0/22"
}

variable "public_subnets" {
  default = "172.18.0.0/22,172.18.4.0/22,172.18.8.0/22"
}

variable "cidr_range" {
  default = "172.18.0.0/19"
}

variable "availability_zones" {
  default = "eu-west-1a,eu-west-1b,eu-west-1c"
}
