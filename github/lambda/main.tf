# Zip the build file
data "archive_file" "lambda_go_zip" {
  type        = "zip"
  source_file = "${path.module}/bin/bootstrap"
  output_path = "${path.module}/bin/handler.zip"
}

# Build and upload package to S3


# # Download package from S3 

# # Lambda module to deploy using terraform
# module "lambda_function" {
#   source = "terraform-aws-modules/lambda/aws"

#   function_name = "tf-cloud-golang-lambda-using-github"
#   description   = "This lambda is being deployed from github"
#   handler       = "bootstrap"
#   runtime       = "provided.al2"
#   architectures = ["arm64"]

#   create_package         = false
#   local_existing_package = "${path.module}/bin/handler.zip"


# }


resource "aws_s3_bucket" "builds" {
  bucket = "my-builds-for-golang-lambda-test"
}
resource "aws_s3_bucket_ownership_controls" "builds" {
  bucket = aws_s3_bucket.builds.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "builds" {
  depends_on = [aws_s3_bucket_ownership_controls.builds]

  bucket = aws_s3_bucket.builds.id
  acl    = "private"
}

# Download package from S3 

# Lambda module to deploy using terraform
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "tf-cloud-golang-lambda-using-github"
  description   = "This lambda is being deployed from github"
  handler       = "bootstrap"
  runtime       = "provided.al2"
  architectures = ["arm64"]

  s3_bucket = aws_s3_bucket.builds.bucket
  s3_key    = "handler.zip"

  depends_on = [aws_s3_bucket.builds]
}