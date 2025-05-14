provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

terraform {
  required_version = ">= 0.12.29"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.74"
    }
  }
/*   backend "s3" {
    bucket         = "t_abeginner-role-terraform-states"
    key            = "t_abeginner-role.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "t_abeginner-role_terraform_state"
    profile        = "default"
  } */
}
