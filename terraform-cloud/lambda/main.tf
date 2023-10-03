data "archive_file" "lambda_go_zip" {
  type        = "zip"
  source_file = "${path.module}/bin/bootstrap"
  output_path = "${path.module}/bin/handler.zip"
}

# Build Golang lambda

# Lambda module to deploy using terraform
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "tf-cloud-golang-lambda"
  description   = "This lambda is being deployed from tf-cloud"
  handler       = "bootstrap"
  runtime       = "provided.al2"

  create_package         = false
  local_existing_package = "${path.module}/bin/handler.zip"

}

