variable "aws_profile" {}
variable "aws_account_no" {}
variable "aws_region" {}
variable "this_name" {}

variable "aws_key_name" {
  description = "Keypair name used to connect to EC2 instances"
  type        = map(string)

  default = {
    ap-southeast-2 = "t_abeginner_ed25519"
  }
}
variable "whitelist" {
  description = "The IP ranges of bastion hosts to ssh web server instances."
  type = list
}
variable "iam_instance_profile_arn" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
  description = "The IP ranges to use for the public subnets in your VPC."
  type = list
}
variable "private_subnet_cidrs" {
  description = "The IP ranges to use for the private subnets in your VPC."
  type = list
}
variable "database_subnet_cidrs" {
  description = "The IP ranges to use for the database subnets in your VPC."
  type = list
}
variable "instance_type" {}

## rds
variable "rds_instance_type" {}
variable "rds_engine_version" {}
variable "rds_family" {}
variable "major_engine_version" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}

## eks
variable "cluster_version" {}

## tags
variable "created_by" {}
variable "link" {}
variable "deployment" {
  description = "How is this stack deployed."
  default     = "terraform"
}
