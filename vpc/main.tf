provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name             = "${var.this_name}"
  cidr             = var.vpc_cidr
  azs              = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets   = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    deployment  = "terraform"
    created_by  = var.created_by
    link        = var.link
  }
}