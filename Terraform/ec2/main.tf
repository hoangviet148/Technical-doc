terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
  assume_role {
      role_arn = "arn:aws:iam::921042051488:role/prod-terraform"
  }
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "aws-prod"
}

resource "aws_instance" "test" {
  count = 1
  ami = "ami-0ff3ebd2da25437ad"
  instance_type = var.instance_type
  tags = {
    name = "test"
  }
}

resource "aws_s3_bucket" "static" {
  bucket = "terraform-series-bai3"
  acl    = "public-read"
  policy = file("s3_static_policy.json")  # file function to load config

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

output "ec2" {
  value = {
    public_ip = { for i, v in aws_instance.test : format("public_ip%d", i + 1) => v.public_ip } # loop
  }
}