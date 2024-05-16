resource "aws_s3_bucket" "builds" {
  bucket = "my-unique-bucket-golang-lambda-test-Ran@2021"
}

# Define ownership controls for the bucket
resource "aws_s3_bucket_ownership_controls" "builds" {
  bucket = aws_s3_bucket.builds.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Define ACL (Access Control List) for the bucket
resource "aws_s3_bucket_acl" "builds" {
  depends_on = [aws_s3_bucket_ownership_controls.builds]

  bucket = aws_s3_bucket.builds.id
  acl    = "private"
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.builds.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Define lifecycle configuration for the bucket
resource "aws_s3_bucket_lifecycle_configuration" "builds" {
  bucket = aws_s3_bucket.builds.id

  rule {
    id     = "previous-versions-rule"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days           = 1
      newer_noncurrent_versions = 2
    }

    filter {
      prefix = "" # Empty prefix to match all objects in the bucket
    }
  }
}