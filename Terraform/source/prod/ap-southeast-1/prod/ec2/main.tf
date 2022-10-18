locals {
  base_ami = yamldecode(file("../common_vars.yaml"))["ami"]
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.21.0"
  
  ami = local.base_ami
  name = "ec2_test"
  instance_type = "t2.micro"
  subnet_id = "subnet-09fc4e50"
}