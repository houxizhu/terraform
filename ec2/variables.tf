variable "aws_profile" {}
variable "aws_account_no" {}
variable "aws_region" {}
variable "vpc_name" {}
variable "sg_name" {}
variable "this_name" {}
variable "created_by" {}
variable "website" {}

variable "aws_ami_prefix" {}
variable "ami_id" {
  description = "Searching aws_ami_prefix if no ami_id defined"
  default = ""
}

variable "ec2_instance_type" {}
variable "volume_size" {
  default = 32
}
variable "iam_instance_profile_name" {
  default = "whichManagedInstanceRoleforSSM"
}

variable "key_name" { 
  description = "aws key name"
  default = "" 
}

variable "aws_key_name" {
  description = "Keypair name used to connect to EC2 instances"
  type        = map(string)

  default = {
    eu-west-1      = "keyEUW1ed25519"
    eu-central-1   = "keyEUC1ed25519"
    us-west-1      = "keyUSW1ed25519"
    us-west-2      = "keyUSW2ed25519"
    us-east-1      = "keyUSE1ed25519"
    us-east-2      = "keyUSE1ed25519"
    ca-central-1   = "keyCAC1ed25519"
    ap-south-1     = "keyAPS1ed25519"
    ap-northeast-1 = "keyAPNE1ed25519"
    ap-southeast-2 = "keyAPSE2ed25519"
    me-south-1     = "keyMES1ed25519"
  }
}
