# Fake-product-assets bucket
module "fake-product-assets" {
  source        = "../modules/s3"
  bucket_name   = "fake-product-assets"
}
