resource "aws_acm_certificate" "cert" {
  domain_name               = "kponics.com"
  subject_alternative_names = ["*.kponics.com"]
  validation_method         = "DNS"

  tags = {
    Name      = "kponics.com"
    Terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn = aws_acm_certificate.cert.arn
}
