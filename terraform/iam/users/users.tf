module "emma" {
  source = "../../modules/iam/users"
  username = "emma"
}

module "liam" {
  source = "../../modules/iam/users"
  username = "liam"
}
