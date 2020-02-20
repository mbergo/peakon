##
## Creates one private and public subnet in each availability zone
##

##
## Parameters (variables)
##

## String, Descriptive name of the Virtual Private Cloud
variable "name" {}

## String, Domain name of environment for search
variable "domain_name_search" {
  default = "fake-product.com"
}

## String, Class inter-domain routing range of IPv4 addresses
variable "cidr" {}

## String, comma separated list of EC2 availability zone ids
variable "availability_zones" {}

## String, comma separated list of CIDR ranges for each public subnet (Public addressable).
variable "public_subnets" {}

## String, comma separated list of CIDR ranges for each private subnet (Internal only).
variable "private_subnets" {}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default = false
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default = false
}

# Boolean, should this VPC allow traffic between classic EC2 networks and this VPC
variable "enable_classiclink" {
  default = false
}

# String, Full environment name (Fx 'staging')
variable "environment_name" {}

# Provider zone & version
provider "aws" {
  region  = "eu-west-1"
  version = "1.60.0"
}

#
# The AWS EC2 Virtual Private Cloud network
#
resource "aws_vpc" "stack" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  enable_classiclink = "${var.enable_classiclink}"
  tags = "${map(
      "Name", "${var.name}",
      "Environment", "${var.environment_name}"
    )}"
}


#
# Control DHCP options (applies to all VPC subnets)
#
resource "aws_vpc_dhcp_options" "stack" {
  domain_name = "${var.name} ${var.domain_name_search}"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags {
    Name = "dhcp.${var.name}"
    Environment = "${var.environment}"
  }
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id = "${aws_vpc.stack.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.stack.id}"
}


#
# Public (Auto-assigned public IP address) subnets
#
resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.stack.id}"
  cidr_block = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  count = "${length(compact(split(",", var.public_subnets)))}"
  tags = "${map(
      "Name", "public.${var.name}",
      "Environment", "${var.environment}"
    )}"
  map_public_ip_on_launch = true
}


#
# Private (non-routable, no public IP address) subnets
#
resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.stack.id}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  count = "${length(compact(split(",", var.private_subnets)))}"
  tags = "${map(
      "Name", "private.${var.name}",
      "Environment", "${var.environment}"
    )}"
}

#
# Default ACL for VPC - Ingress 8080
#
resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.stack.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

#
# Human-readable output
#
output "private_subnets" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "public_subnets" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "vpc_id" {
  value = "${aws_vpc.stack.id}"
}

output "cidr" {
  value = "${var.cidr}"
}
