data "aws_iam_policy_document" "kponics-bucket-ops-policy-document" {
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

resource "aws_iam_policy" "kponics-bucket-ops-policy" {
  name        = "kponics-bucket-ops-policy"
  description = "Policy for reading, writing, and deleting files in the bucket hosting kponics.com"

  policy = data.aws_iam_policy_document.kponics-bucket-ops-policy-document.json
}

resource "aws_iam_group" "bucket-ops" {
  name = "kponics-bucket-ops"
}

resource "aws_iam_group_policy_attachment" "bucket-ops-policy-attachment" {
  group      = aws_iam_group.bucket-ops.name
  policy_arn = aws_iam_policy.kponics-bucket-ops-policy.arn
}

resource "aws_iam_group_membership" "bucket-ops-membership" {
  name = "kponics-bucket-ops-membership"

  users = [
    "${aws_iam_user.kponics.name}",
  ]

  group = aws_iam_group.bucket-ops.name
}

resource "aws_iam_user" "kponics" {
  name = "kponics"

  tags = {
    "Name" = "kponics"
  }
}
