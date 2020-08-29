resource "aws_iam_user" "kponics" {
  name = "kponics"

  tags = {
    "Name" = "kponics"
  }
}

resource "aws_iam_role" "kponics-bucket-ops" {
  name              = "kponics-bucket-ops"
  assume_role_policy = data.aws_iam_policy_document.kponics-bucket-ops-assume-role-policy-document.json
}

resource "aws_iam_role_policy_attachment" "kponics-bucket-ops" {
  role       = aws_iam_role.kponics-bucket-ops.name
  policy_arn = aws_iam_policy.kponics-bucket-ops-policy.arn

}

resource "aws_iam_policy" "kponics-bucket-ops-policy" {
  name        = "kponics-bucket-ops-policy"
  description = "Policy for reading, writing, and deleting files in the bucket hosting kponics.com"

  policy = data.aws_iam_policy_document.kponics-bucket-ops-policy-document.json
}

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

data "aws_iam_policy_document" "kponics-bucket-ops-assume-role-policy-document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"
      identifiers = [aws_iam_user.kponics.arn]
    }
  }
}
