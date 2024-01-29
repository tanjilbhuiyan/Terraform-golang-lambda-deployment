output "s3-bucket-function_name" {
  value = aws_s3_bucket.builds.bucket
  # This output represents the name of the S3 bucket used by the function
}