# module "golang-lambda-1" {
#   source    = "./lambda/github-lambda-test-1"
#   s3_bucket = module.golang-lambda-bucket.s3-bucket-function_name
# }
# module "golang-lambda-2" {
#   source    = "./lambda/github-lambda-test-2"
#   s3_bucket = module.golang-lambda-bucket.s3-bucket-function_name
# }


module "golang-lambda-bucket" {
  source = "./s3"
}


# AWS Provider
provider "aws" {}



