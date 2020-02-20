module "fake-product-production" {
  source = "../../modules/vpc"
  name                 = "${var.name}"
  domain_name_search   = "${var.domain_name_search}"
  cidr                 = "${var.cidr_range}"

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_classiclink   = false

  availability_zones   = "${var.availability_zones}"
  private_subnets      = "${var.private_subnets}"
  public_subnets       = "${var.public_subnets}"
  environment          = "${var.environment_name}"
}
