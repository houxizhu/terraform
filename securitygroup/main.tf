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
  name        = "${var.this_name}-${var.region_city[var.aws_region]}-${var.vpc_name}-${var.openport}"
  description = "xhou - ${var.openport}"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description      = "xhou - ${var.openport}"
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
    Name       = "${var.this_name}-${var.region_city[var.aws_region]}-${var.vpc_name}-${var.openport}"
    customer   = "${var.this_name}"
    type       = var.tag_type
    deployment = "terraform"
    jira       = var.jira
    owner      = var.owner
    terraform  = "xhou/securitygroup/port"
  }

  lifecycle {
    create_before_destroy = true
  }
}
