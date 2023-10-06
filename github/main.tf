# module "golang-lambda-1" {
#   source = "./lambda/github-lambda-test-1"
# }
# module "golang-lambda-2" {
#   source = "./lambda/github-lambda-test-2"
# }


module "golang-lambda-bucket" {
  source = "./s3"
}


# AWS Provider
provider "aws" {}



