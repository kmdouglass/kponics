resource "aws_s3_bucket" "kponics-bucket" {
  bucket = var.kponics_bucket
  acl    = "public-read"
  policy = data.aws_iam_policy_document.kponics-bucket-policy.json

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = "kponics.com Bucket"
  }
}

data "aws_iam_policy_document" "kponics-bucket-policy" {
  statement {
    sid = "PublicReadGetObject"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.kponics_bucket}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "www-kponics-bucket" {
  bucket = var.www_kponics_bucket

  website {
    redirect_all_requests_to = "kponics.com"
  }

  tags = {
    Name = "www.kponics.com Bucket"
  }
}
