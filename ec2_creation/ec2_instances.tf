provider "aws" {
   region = "ap-south-1"
}

data "terraform_remote_state" "vpc_infra" {
  backend = "local"

  config = {
    path = "../infra_creation/terraform.tfstate"
  }
}

# Create EC2 instances in the hub and spoke subnets
resource "aws_instance" "hub_ec2_instance" {
  ami             = "ami-0645cf88151eb2007" # RedHat AMI
  instance_type   = "t2.micro"
  subnet_id       = data.terraform_remote_state.vpc_infra.outputs.sig_management_subnet_id
  key_name        = "oskeypair"
  security_groups = [data.terraform_remote_state.vpc_infra.outputs.sg_hub_id]
  tags = {
    Name = "SIG_Hub_management_EC2"
  }
}

resource "aws_instance" "spoke_ec2_instance" {
  ami             = "ami-0645cf88151eb2007" # RedHat AMI
  instance_type   = "t2.micro"
  subnet_id       = data.terraform_remote_state.vpc_infra.outputs.sig_production_subnet_id
  key_name        = "oskeypair"
  security_groups = [data.terraform_remote_state.vpc_infra.outputs.sg_spoke_id]
  tags = {
    Name = "SIG_Spoke_production_EC2"
  }
}
