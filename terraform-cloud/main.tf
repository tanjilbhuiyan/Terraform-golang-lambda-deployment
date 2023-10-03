# AWS Provider
provider "aws" {}

# Check if the source file has changed
data "external" "check_file_change" {
  program = ["sh", "-c", "stat -c %Y lambda/src/main.go"]
}

# Conditional execution based on file change
resource "null_resource" "trigger_golang_lambda" {
  count = data.external.check_file_change.result != "" ? 1 : 0

  triggers = {
    source_file_change = data.external.check_file_change.result
  }

  # Run the Lambda module when the file changes
  provisioner "local-exec" {
    command = "echo File changed; terraform apply -target=module.golang-lambda"
  }
}

# Lambda
module "golang-lambda" {
  source = "./lambda"
}
