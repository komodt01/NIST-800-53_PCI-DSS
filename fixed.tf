#############################################
# VARIABLES
#############################################

# Supply your CMK ID/ARN via TF vars or the pipeline
variable "kms_key_id" {
  description = "KMS CMK ARN or ID to encrypt S3 buckets"
  type        = string
}

#############################################
# DATA BUCKET (your existing bucket, hardened)
#############################################

resource "aws_s3_bucket" "fixed" {
  bucket = "demo-private-bucket-12345"
  tags = {
    confidentiality = "internal"
  }
}

# Block all forms of public access
resource "aws_s3_bucket_public_access_block" "fixed" {
  bucket                  = aws_s3_bucket.fixed.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "fixed" {
  bucket = aws_s3_bucket.fixed.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption with a customer-managed KMS key (CMK)
resource "aws_s3_bucket_server_side_encryption_configuration" "fixed" {
  bucket = aws_s3_bucket.fixed.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_id
    }
  }
}

#############################################
# LOGS BUCKET (receives access logs, hardened)
#############################################

resource "aws_s3_bucket" "fixed_logs" {
  bucket = "demo-private-bucket-logs-12345" # must be globally unique
  tags = {
    purpose = "s3-access-logs"
  }
}

# Block all forms of public access on logs bucket
resource "aws_s3_bucket_public_access_block" "fixed_logs" {
  bucket                  = aws_s3_bucket.fixed_logs.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Enable versioning on logs bucket
resource "aws_s3_bucket_versioning" "fixed_logs" {
  bucket = aws_s3_bucket.fixed_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# CMK encryption on logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "fixed_logs" {
  bucket = aws_s3_bucket.fixed_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_id
    }
  }
}

#############################################
# DATA BUCKET -> LOGS BUCKET LOGGING
#############################################

resource "aws_s3_bucket_logging" "fixed" {
  bucket        = aws_s3_bucket.fixed.id
  target_bucket = aws_s3_bucket.fixed_logs.id
  target_prefix = "s3-access-logs/"
}

# 4) Enable server access logging on the main bucket, writing into the logs bucket
resource "aws_s3_bucket_logging" "fixed_logging" {
  bucket        = aws_s3_bucket.fixed.id           # the bucket to log FROM
  target_bucket = aws_s3_bucket.fixed_logs.id      # the bucket to log TO
  target_prefix = "s3-access/"                      # optional prefix in the logs bucket
}
