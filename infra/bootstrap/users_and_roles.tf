data "aws_iam_policy_document" "kponics-bucket-admins-policy-document" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.kponics_bucket}",
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.kponics_bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "kponics-bucket-admins-policy" {
  name        = "kponics-bucket-admins-policy"
  description = "Policy for reading, writing, and deleting files in the bucket hosting kponics.com"

  policy = data.aws_iam_policy_document.kponics-bucket-admins-policy-document.json
}

resource "aws_iam_group" "bucket-admins" {
  name = "kponics-bucket-admins"
}

resource "aws_iam_group_policy_attachment" "bucket-admins-policy-attachment" {
  group      = aws_iam_group.bucket-admins.name
  policy_arn = aws_iam_policy.kponics-bucket-admins-policy.arn
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
