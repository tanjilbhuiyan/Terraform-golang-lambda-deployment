# Build and upload package to S3


# Download package from S3 

# Lambda module to deploy using terraform
module "lambda_function" {
    source = "terraform-aws-modules/lambda/aws"

    function_name = "my-lambda-existing-package-local"
    description   = "My awesome lambda function"
    handler       = "lambda_function.handler"
    runtime       = "provided.al2"

    create_package         = false
    local_existing_package = "../existing_package.zip"
}

