resource "aws_s3_bucket" "kponics-bucket" {
  bucket = var.kponics_bucket
  acl    = "private"

  tags = {
    Name = "Kponics Bucket"
  }
}
