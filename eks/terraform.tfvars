## instance
instance_type = "t3a.micro"
whitelist     = [
    "203.123.0.0/16",      ### home ip
    ]

#iam_instance_profile_arn = "arn:aws:iam::471112672291:instance-profile/abeginner_instance_profile"
iam_instance_profile_arn = "arn:aws:iam::471112672291:instance-profile/eks-node-instance-profile"
## vpc
vpc_cidr              = "10.195.0.0/16"
public_subnet_cidrs   = ["10.195.10.0/24", "10.195.11.0/24"]
private_subnet_cidrs  = ["10.195.20.0/24", "10.195.21.0/24"]
database_subnet_cidrs = ["10.195.30.0/24", "10.195.31.0/24"]

## rds
dbname               = "abeginner"
dbuser               = "abeginner"
dbpassword           = "adevopsbeginnerpwd"
rds_instance_type    = "db.t3.medium"
rds_engine_version   = "17.4"
rds_family           = "postgres17"
major_engine_version = "17"

## eks
#cluster_version = "1.27"
cluster_version = "1.32" # rancher-2.7.5
