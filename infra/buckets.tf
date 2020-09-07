resource "aws_s3_bucket" "kponics-bucket" {
  bucket = var.kponics_bucket
  acl    = "private"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name      = "kponics.com Bucket"
    Terraform = "true"
  }
}

data "aws_iam_policy_document" "kponics-bucket-policy-document" {
  statement {
    sid = "CloudFrontGetObject"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.kponics-bucket.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin-access-identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "kponics-bucket-policy" {
  bucket = aws_s3_bucket.kponics-bucket.id
  policy = data.aws_iam_policy_document.kponics-bucket-policy-document.json
}

resource "aws_s3_bucket" "kponics-distribution-logs-bucket" {
  bucket = var.kponics_distribution_logs_bucket
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name      = "kponics.com Distribution Logs"
    Terraform = "true"
  }
}
