resource "aws_cloudfront_origin_access_identity" "origin-access-identity" {}

resource "aws_cloudfront_distribution" "kponics-distribution" {
  origin {
    domain_name = aws_s3_bucket.kponics-bucket.bucket_regional_domain_name
    origin_id   = var.kponics_cloudfront_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin-access-identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "kponics.com"
  default_root_object = "index.html"

  logging_config {
    bucket          = aws_s3_bucket.kponics-distribution-logs-bucket.bucket_domain_name
  }

  aliases = ["kponics.com", "www.kponics.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.kponics_cloudfront_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name      = "kponics.com CloudFront Distribution"
    Terraform = "true"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}
