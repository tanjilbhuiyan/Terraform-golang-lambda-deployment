# Zip the build file
data "archive_file" "lambda_go_zip" {
  type        = "zip"
  source_file = "${path.module}/bin/bootstrap"
  output_path = "${path.module}/bin/handler.zip"
}

# Build and upload package to S3


# Download package from S3 

# Lambda module to deploy using terraform
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "tf-cloud-golang-lambda-using-github"
  description   = "This lambda is being deployed from github"
  handler       = "bootstrap"
  runtime       = "provided.al2"
  architectures = ["arm64"]

  create_package         = false
  local_existing_package = "${path.module}/bin/handler.zip"

}
