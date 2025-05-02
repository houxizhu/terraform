variable "aws_profile" {}
variable "aws_account_no" {}
variable "aws_region" {}
variable "vpc_name" {}
variable "this_name" {}
variable "whitelist_cidrs" {}
variable "openport" {}
variable "created_by" {}
variable "link" {}

variable "region_city" {
  description = "to map aws region to aws city name"
  type        = map(string)

  default = {
    eu-west-1      = "ireland"
    eu-central-1   = "frankfurt"
    us-west-1      = "california"
    us-west-2      = "oregon"
    us-east-1      = "virginia"
    us-east-2      = "ohio"
    ca-central-1   = "canada"
    ap-south-1     = "mumbai"
    ap-northeast-1 = "tokyo"
    ap-southeast-2 = "sydney"
    me-south-1     = "bahrain"
    me-central-1   = "uae"
  }
}
