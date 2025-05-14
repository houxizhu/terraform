variable "aws_profile" {}
variable "aws_account_no" {}
variable "aws_region" {}
variable "this_name" {}
variable "created_by" {}
variable "link" {}

variable "vpc_cidr" {
  description = "The IP range to attribute to the virtual network."
}
variable "public_subnet_cidrs" {
  description = "The IP ranges to use for the public subnets in your VPC."
  type = list
}
variable "private_subnet_cidrs" {
  description = "The IP ranges to use for the private subnets in your VPC."
  type = list
}
