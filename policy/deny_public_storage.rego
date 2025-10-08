package storage.security
deny[msg] {
  input.resource_type == "aws_s3_bucket"
  input.acl == "public-read"
  msg := sprintf("Public S3 bucket blocked: %s", [input.name])
}
