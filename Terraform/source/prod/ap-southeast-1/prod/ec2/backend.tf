# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "hoangnv46-test-921042051488"
    dynamodb_table = "hoangnv46-test-locks-921042051488"
    encrypt        = true
    key            = "prod/ap-southeast-1/prod/ec2/terraform.tfstate"
    region         = "ap-southeast-1"
  }
}