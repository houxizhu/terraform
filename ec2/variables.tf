variable "aws_profile" {}
variable "aws_account_no" {}
variable "aws_region" {}
variable "vpc_name" {}
variable "sg_name" {}
variable "this_name" {}
variable "created_by" {}
variable "link" {}

variable "aws_ami_prefix" {}
variable "ami_id" {
  description = "Searching aws_ami_prefix if no ami_id defined"
  default = ""
}

variable "ec2_instance_type" {}
variable "volume_size" {
  default = 16
}
variable "iam_instance_profile_name" {
  default = "eks-node-instance-profile"
}

variable "key_name" { 
  description = "aws key name"
  default = "" 
}

variable "aws_key_name" {
  description = "Keypair name used to connect to EC2 instances"
  type        = map(string)

  default = {
    ap-southeast-2 = "t_abeginner_ed25519"
  }
}
