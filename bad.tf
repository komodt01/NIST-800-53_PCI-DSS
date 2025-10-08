resource "aws_s3_bucket" "bad" {
  bucket = "demo-public-bucket-12345"
  acl    = "public-read"
}
