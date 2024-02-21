terraform {

  cloud{
    organization = "jv-skillstorm-cohort"

    workspaces {
      name = "jverdecia-dev" # dev or prod
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
  }
}

# Student Used Provider

# provider "aws" {
#   profile = "terraformcloud-demo"
#   default_tags {
#     tags = {
#       env = "dev"
#     }
#   }
# }

# New Provider Block
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      env = "dev"
    }
  }
}

module "VPC"{
  source = "./modules/vpc"
  availability_zone = data.aws_availability_zones.main.names
}

module "EC2"{
  source = "./modules/ec2"
  vpc_id = module.VPC.vpc_id
  subnet_id = module.VPC.public_subnet_id
  instance_ami = data.aws_ssm_parameter.instance_ami.value
}