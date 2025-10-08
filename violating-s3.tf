resource "aws_s3_bucket" "violating" {
  bucket = "demo-public-bucket-12345"
  acl    = "public-read"
}
