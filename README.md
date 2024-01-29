# Golang Lambda Deployment using Terraform & S3 Bucket

Golang Lambda deployment using terraform and S3 Bucket for storing binary.

## Table of Contents

- [Problem trying to solve](#problem)
- [License](#license)


## Problem trying to solve

The Golang lmabda need to be built and zipped before updating and deploying it as lambda. 

We want to automate the build and deployment process using terraform. To track down the golang binary version , we are storing binary in S3.

## License

This project is licensed under the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/), which allows for free use of the code.
