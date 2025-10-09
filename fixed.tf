resource "aws_s3_bucket" "fixed" {
  bucket = "demo-private-bucket-12345"
  acl    = "private"

  tags = {
    confidentiality = "internal"
  }
}

# 1) Block ALL forms of public access on this bucket
resource "aws_s3_bucket_public_access_block" "fixed" {
  bucket                  = aws_s3_bucket.fixed.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2) Require TLS (deny any non-HTTPS S3 requests)
resource "aws_s3_bucket_policy" "require_tls" {
  bucket = aws_s3_bucket.fixed.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.fixed.arn,
          "${aws_s3_bucket.fixed.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = false
          }
        }
      }
    ]
  })
}

# 3) Default encryption at rest (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "fixed" {
  bucket = aws_s3_bucket.fixed.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_default.arn
    }
  }
}
# KMS key for default encryption
resource "aws_kms_key" "s3_default" {
  description         = "CMK for S3 default encryption (demo)"
  enable_key_rotation = true
}

# Logging target bucket (must be a different bucket name)
resource "aws_s3_bucket" "fixed_logs" {
  bucket = "demo-private-bucket-logs-12345"
}

# Enable access logging to the logs bucket
resource "aws_s3_bucket_logging" "fixed" {
  bucket        = aws_s3_bucket.fixed.id
  target_bucket = aws_s3_bucket.fixed_logs.id
  target_prefix = "logs/"
}

# Enable versioning
resource "aws_s3_bucket_versioning" "fixed" {
  bucket = aws_s3_bucket.fixed.id
  versioning_configuration {
    status = "Enabled"
  }
}

