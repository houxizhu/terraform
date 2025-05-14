locals {
  tags = {
    Name        = var.this_name
    deployment  = var.deployment
    created_by  = var.created_by
    link        = var.link
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.0"

  name             = "${var.this_name}"
  cidr             = var.vpc_cidr
  azs              = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets   = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs
  database_subnets = var.database_subnet_cidrs
  
  enable_dns_support   = true
  enable_dns_hostnames = true

  map_public_ip_on_launch = true

  tags = {
    deployment  = var.deployment
    created_by  = var.created_by
    link        = var.link
  }
}

resource "aws_security_group" "this" {
  name        = "${var.this_name}-eks-sg"
  description = "${var.this_name}-eks-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.whitelist
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.this_name}-eks-sg"
    deployment  = var.deployment
    created_by  = var.created_by
    link        = var.link
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_security_group" "rds" {
#   name        = "${var.this_name}-eks-rds-sg"
#   description = "Allow access to RDS database"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description      = "PSQL access from worker nodes"
#     from_port        = 5432
#     to_port          = 5432
#     protocol         = "tcp"
#     #cidr_blocks      = ["0.0.0.0/0"]                 ### no 0.0.0.0/0 allowed
#     security_groups  = [aws_security_group.this.id]  ### the EKS cluster security group
#     #security_groups  = ["sg-042182e5990df2a82"]       ### workaround for the euwest1

#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name        = "${var.this_name}-eks-rds-sg"
#     deployment  = var.deployment
#     created_by  = var.created_by
#     link        = var.link
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# module "db" {
#   source  = "terraform-aws-modules/rds/aws"
#   version = "~>5.0"

#   identifier = "${var.this_name}-eks-rds"

#   engine               = "postgres"
#   engine_version       = var.rds_engine_version
#   family               = var.rds_family
#   major_engine_version = var.major_engine_version
#   instance_class       = var.rds_instance_type

#   allocated_storage     = 16
#   max_allocated_storage = 512
#   storage_encrypted     = false

#   db_name  = var.dbname
#   username = var.dbuser
#   password = var.dbpassword
#   create_random_password = false

#   create_db_subnet_group      = true
#   db_subnet_group_description = "Subnets for manual RDS"
#   db_subnet_group_name        = "${var.this_name}-eks-rds-subnets"

#   multi_az                    = false
#   auto_minor_version_upgrade  = true
  
#   subnet_ids             = module.vpc.database_subnets
#   vpc_security_group_ids = [aws_security_group.rds.id]
#   #maintenance_window              = "Mon:00:00-Mon:03:00"
#   #backup_window                   = "03:00-06:00"
#   #enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

#   backup_retention_period = 7
#   skip_final_snapshot     = true
#   deletion_protection     = false

#   performance_insights_enabled          = false
#   performance_insights_retention_period = 10
#   create_monitoring_role                = false
#   monitoring_interval                   = 0

#   ### only lowercase alphanumeric characters and hyphens allowed in parameter group "name_prefix"
#   parameter_group_name = "${var.this_name}-postgresql-ssl"
#   parameters = [
#     {
#       name  = "rds.force_ssl"
#       value = 1
#     }
#   ]

#   tags = local.tags
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.this_name}-cluster"
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  #enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [/*{
    provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
    resources        = ["secrets"]
  }*/]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_group_defaults = {
    disk_size      = 16
    instance_types = [var.instance_type]

    min_size     = 1
    max_size     = 3
    desired_size = 1

    capacity_type  = "SPOT" ## "ON_DEMAND | SPOT"

    #create_launch_template = false

    # with remote_access enabled, destroying node group failed a few times due to untached security group
    # remote_access = {
    #   ec2_ssh_key               = var.aws_key_name[var.aws_region]
    #   source_security_group_ids = [aws_security_group.this.id]
    # }

    tags = local.tags
  }

  eks_managed_node_groups = {
    "${var.this_name}-uno" = {
      tags     = local.tags
    }
    # "${var.this_name}-dos" = {
    #   tags = local.tags
    # }
  }

  access_entries = {
    "abeginner" = {
      principal_arn = "arn:aws:iam::471112672291:user/abeginner"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
    "eks-access-role" = {
      principal_arn = "arn:aws:iam::471112672291:role/eks-access-role"
      policy_associations = {
        view = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }

  ### legacy after eks module v20+
  # # aws-auth configmap, default = true
  # manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::${var.aws_account_no}:role/EKSAdmin"
  #     username = "eksadmin"
  #     groups   = ["system:masters"]
  #   },
  # ]

  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::${var.aws_account_no}:user/abeginner"
  #     username = "abeginner"
  #     groups   = ["system:masters"]
  #   }
  # ]

  # aws_auth_accounts = [ var.aws_account_no ]

  tags = local.tags
}

# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.cluster_name
# }

# # Step 2: Set up the Kubernetes provider using EKS data
# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

# # Step 3: Manage aws-auth ConfigMap via Kubernetes provider
# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = "arn:aws:iam::471112672291:role/eks-access-role"
#         username = "eks-access-role"
#         groups   = ["system:masters"]
#       }
#     ])
#   }
# }

# module "aws_auth" {
#   source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
#   version = "~> 20.0"

#   providers = {
#     kubernetes = kubernetes
#   }

#   depends_on = [module.eks]

#   eks_cluster_name                          = module.eks.cluster_name
#   eks_cluster_endpoint                      = module.eks.cluster_endpoint
#   eks_cluster_certificate_authority_data   = module.eks.cluster_certificate_authority_data
#   manage_aws_auth_configmap                 = true

#   roles = [
#     {
#       rolearn  = var.eks_access_role_arn
#       username = "eks-access-role"
#       groups   = ["system:masters"]
#     }
#   ]

#   aws_auth_roles = [
#     {
#       rolearn  = "arn:aws:iam::${var.aws_account_no}:role/eks-access-role"
#       username = "eksadmin"
#       groups   = ["system:masters"]
#     },
#   ]

#   aws_auth_users = [
#     {
#       userarn  = "arn:aws:iam::${var.aws_account_no}:user/abeginner"
#       username = "abeginner"
#       groups   = ["system:masters"]
#     }
#   ]

#   aws_auth_accounts = [ var.aws_account_no ]
# }