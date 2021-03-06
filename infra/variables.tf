variable "bucket" {
  description = "AWS S3 bucket to use for the Terraform remote state"
  type        = string
}

variable "dynamodb_table" {
  description = "AWS DynamoDB table name to use for state locking"
  type        = string
}

variable "region" {
  description = "The AWS region that will contain the bucket for the remote state"
  type        = string
}

variable "kponics_bucket" {
  description = "AWS S3 bucket to use for kponics.com"
  type        = string
}

variable "kponics_cloudfront_origin_id" {
  description = "The CloudFront distribution's origin ID"
  type        = string
}

variable "kponics_distribution_logs_bucket" {
  description = "AWS S3 bucket to use for storing the CloudFront distribution logs"
  type        = string
}

variable "www_kponics_bucket" {
  description = "AWS S3 bucket to use for www.kponics.com"
  type        = string
}
