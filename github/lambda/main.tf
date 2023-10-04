# # Zip the build file
# data "archive_file" "lambda_go_zip" {
#   type        = "zip"
#   source_file = "${path.module}/bin/bootstrap"
#   output_path = "${path.module}/bin/handler.zip"
# }

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
data "aws_s3_object" "application_zip" {
  bucket = "my-builds-for-golang-lambda-test"
  key    = "handler.zip"
}

# Lambda module to deploy using terraform
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name  = "tf-cloud-golang-lambda-using-github"
  description    = "This lambda is being deployed from github"
  handler        = "bootstrap"
  runtime        = "provided.al2"
  architectures  = ["arm64"]
  create_package = false
  s3_existing_package = {
    bucket     = data.aws_s3_object.application_zip.bucket
    key        = data.aws_s3_object.application_zip.key
    version_id = data.aws_s3_object.application_zip.version_id
  }


  depends_on = [aws_s3_bucket.builds]
}


# Raw

# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "iam_for_lambda" {
#   name               = "iam_for_lambda_new"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

# # Zip the build file
# data "archive_file" "lambda_go_zip" {
#   type        = "zip"
#   source_file = "${path.module}/bin/bootstrap"
#   output_path = "${path.module}/bin/handler.zip"
# }
# data "aws_s3_object" "application_zip" {
#   bucket = "my-builds-for-golang-lambda-test"
#   key    = "handler.zip"
# }

# resource "aws_lambda_function" "test_lambda" {
#   # If the file is not in the current working directory you will need to include a
#   # path.module in the filename.
#   # filename      = "${path.module}/bin/handler.zip"
#   function_name = "tf-cloud-golang-lambda-using-github"
#   role          = aws_iam_role.iam_for_lambda.arn
#   handler       = "bootstrap"
#   s3_bucket     = "my-builds-for-golang-lambda-test"
#   s3_key        = "handler.zip"

#   s3_object_version = data.aws_s3_object.application_zip.version_id
#   runtime           = "provided.al2"
#   architectures     = ["arm64"]
# }
