# Variables
variable "username" {}

variable "bucket_name" {}


# User creation
resource "aws_iam_user" "system_user" {
    name = "${var.username}"
    path = "/system/"
}

# User policy
resource "aws_iam_policy" "bucket_rw" {
    name = "${var.bucket_name}_rw"
    description = "RW on ${var.bucket_name} bucket"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*",
      "Principal": {
        "AWS": "*"
      }
    }
  ]
}
EOF
}

# Policy Attachment
resource "aws_iam_policy_attachment" "allow_rw_on_bucket" {
    name       = "bucket-attachment-rw"
    users      = ["${aws_iam_user.system_user}"]
    policy_arn = "${aws_iam_policy.bucket_rw.arn}"
}
