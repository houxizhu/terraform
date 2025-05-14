provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.vpc_name}-${var.region_city[var.aws_region]}-${var.this_name}-${var.openport}"
  description = "port - ${var.openport}"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description      = "port - ${var.openport}"
    from_port        = var.openport
    to_port          = var.openport
    protocol         = "tcp"
    cidr_blocks      = var.whitelist_cidrs
  }

  egress {
    description      = "outbound - all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.vpc_name}-${var.region_city[var.aws_region]}-${var.this_name}-${var.openport}"
    this_name  = "${var.this_name}"
    deployment = "terraform"
    terraform  = "terraform/securitygroup/port"
    created_by = var.created_by
    link       = var.link
  }

  lifecycle {
    create_before_destroy = true
  }
}