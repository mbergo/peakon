# Creates a system user with RW on any given bucket
module "fake-product-to-assets" {
  source      = "../../iam/system"
  username    = "fake-product"
  bucket_name = "fake-product-assets"
}
