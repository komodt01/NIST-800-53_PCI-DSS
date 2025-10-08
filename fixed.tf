resource "aws_s3_bucket" "fixed" {
  bucket = "demo-private-bucket-12345"
  acl    = "private"
  server_side_encryption_configuration {
    rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
  }
  tags = { confidentiality = "internal" }
}
