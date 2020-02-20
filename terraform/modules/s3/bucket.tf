#
# Module for a simple private bucket
#

# Bucket name
variable "bucket_name" {}

# Versioning (snapshots)
variable "versioning" {
  default = false
}


# Bucket resource private
resource "aws_s3_bucket" "bucket" {

    bucket = "${var.bucket_name}"
    acl    = "private"
    versioning {
        enabled = "${var.versioning}"
    }

    tags {
        Name      = "${var.bucket_name}"
        Versioned = "${var.versioning}"
    }
}
