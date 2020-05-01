locals {
  s3_full_access_policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group" "bucket-admins" {
  name = "kponics-bucket-admins"
}

resource "aws_iam_group_policy_attachment" "bucket-admins-policy-attachment" {
  group      = aws_iam_group.bucket-admins.name
  policy_arn = local.s3_full_access_policy_arn
}

resource "aws_iam_group_membership" "bucket-admins-membership" {
  name = "kponics-bucket-admins-membership"

  users = [
    "${aws_iam_user.kponics.name}",
  ]

  group = aws_iam_group.bucket-admins.name
}

resource "aws_iam_user" "kponics" {
  name = "kponics"

  tags = {
    "Name" = "kponics"
  }
}
