aws_profile     = "default"
aws_account_no  = "471112672291"
aws_region      = "ap-southeast-2"
tag_type        = "devops"
this_name       = "vpc2"
jira            = "jira-xhou"
owner           = "xhou"

vpc_cidr = "10.200.0.0/16"
public_subnet_cidrs   = ["10.200.10.0/24", "10.200.11.0/24"]
private_subnet_cidrs  = ["10.200.20.0/24", "10.200.21.0/24"]
database_subnet_cidrs = ["10.200.30.0/24", "10.200.31.0/24"]
