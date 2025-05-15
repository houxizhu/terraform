locals {
  tags = {
    Name        = var.this_name
    deployment  = "terraform"
    created_by  = var.created_by
    link        = var.link
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    Name = "*rivate*"
  }
}

data "aws_security_group" "sg443" {
  name   = var.sg_name
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_security_group" "rds" {
  name        = "${var.this_name}-rds-sg"
  description = "Access RDS database"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description      = "PSQL access"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]                 ### no 0.0.0.0/0 allowed
    security_groups  = [data.aws_security_group.sg443.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.this_name}-rds-sg"
    deployment  = "terraform"
    created_by  = var.created_by
    link        = var.link
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~>5.0"

  identifier = "${var.this_name}-rds"

  engine               = "postgres"
  engine_version       = var.rds_engine_version
  family               = var.rds_family
  major_engine_version = var.major_engine_version
  instance_class       = var.rds_instance_type

  allocated_storage     = 16
  max_allocated_storage = 512
  storage_encrypted     = false

  db_name  = var.dbname
  username = var.dbuser
  password = var.dbpassword
  create_random_password = false

  create_db_subnet_group      = true
  db_subnet_group_description = "Subnets for manual RDS"
  db_subnet_group_name        = "${var.this_name}-rds-subnets"

  multi_az                    = false
  auto_minor_version_upgrade  = true
  
  subnet_ids             = data.aws_subnets.subnets.ids
  vpc_security_group_ids = [aws_security_group.rds.id]

  #maintenance_window              = "Mon:00:00-Mon:03:00"
  #backup_window                   = "03:00-06:00"
  #enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = false
  performance_insights_retention_period = 10
  create_monitoring_role                = false
  monitoring_interval                   = 0

  ### only lowercase alphanumeric characters and hyphens allowed in parameter group "name_prefix"
  parameter_group_name = "${var.this_name}-postgresql-ssl"
  parameters = [
    {
      name  = "rds.force_ssl"
      value = 1
    }
  ]

  tags = local.tags
}
