# Build and upload package to S3


# Download package from S3 

# Lambda module to deploy using terraform
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "tf-cloud-golang-lambda-using-github"
  description   = "This lambda is being deployed from tf-cloud"
  handler       = "bootstrap"
  runtime       = "provided.al2"
  architectures = ["arm64"]

  create_package         = false
  local_existing_package = "${path.module}/bin/handler.zip"

}
