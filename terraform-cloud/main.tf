# AWS Provider
provider "aws" {}

module "golang-lambda" {
  source = "./lambda"
}