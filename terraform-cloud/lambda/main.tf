# Create a local directory to build and store the ZIP file
resource "terraform_data" "install_golang" {
  # Run the build script
  provisioner "local-exec" {
    command = "wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz && tar -xvzf go1.21.1.linux-amd64.tar.gz && go/bin/go version"
  }
  provisioner "local-exec" {
    command = "cd src && ls -la"
  }
}

# # Build Golang lambda

# # Lambda module to deploy using terraform
# module "lambda_function" {
#   source = "terraform-aws-modules/lambda/aws"

#   function_name = "tf-cloud-golang-lambda"
#   description   = "This lambda is being deployed from tf-cloud"
#   handler       = "lambda_function.handler"
#   runtime       = "provided.al2"

#   create_package         = false
#   local_existing_package = "../bin/handler.zip"

#   depends_on = [terraform_data.install_golang]
# }

