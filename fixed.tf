resource "aws_s3_bucket" "fixed" {
  bucket = "demo-private-bucket-12345"
  acl    = "private"
  server_side_encryption_configuration {
    rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
  }
  tags = { confidentiality = "internal" }
}
# 1) Block every form of public access for this bucket
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
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          aws_s3_bucket.fixed.arn,
          "${aws_s3_bucket.fixed.arn}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = false }
        }
      }
    ]
  })
}
