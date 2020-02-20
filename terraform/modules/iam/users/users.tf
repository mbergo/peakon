## Parameters:
variable "username" {}

# Create a user
resource "aws_iam_user" "user" {
    name = "${var.username}"
    path = "/users/administrators/"
}

# Attach admin policy to user
resource "aws_iam_policy_attachment" "admin_access" {
    name       = "administrators_policy"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    users      = ["${aws_iam_user.user}"]
}
