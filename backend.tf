provider "aws" {
  region = "${var.aws_region}"
}

# Terraform 0.9.5 suffered from https://github.com/hashicorp/terraform/issues/14399, which causes this template the
# conditionals in this template to fail.
terraform {
  required_version = ">= 0.9.3, != 0.9.5"
  backend "s3" {
    encrypt = true
    bucket = "koralamode-terraform-remote-state-storage-s3"
    dynamodb_table = "koralamode-terraform-state-lock-dynamo"
    region = "us-east-1"
    key = "koralamode.tfstate"
    kms_key_id = "3bac6890-68fc-45a9-9e6a-a81aa85e30ec"
  }
}
