locals {
  tags = {
    Name            = var.this_name
    deployment      = "terraform"
    created_by      = var.created_by
    link            = var.link
  }
}

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

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    Name = "*ublic*"
  }
}

data "aws_security_group" "sg" {
  filter {
    name   = "group-name"
    values = [var.sg_name]
  }
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.aws_ami_prefix}*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars = {
    region            = var.aws_region
    this_name         = var.this_name
  }
}

resource "aws_instance" "ec2" {
  ami                         = ( var.ami_id == "" )? data.aws_ami.ami.id : var.ami_id
  instance_type               = var.ec2_instance_type
  key_name                    = ( var.key_name != "" )? var.key_name : var.aws_key_name[var.aws_region]
  #iam_instance_profile        = var.iam_instance_profile_name

  subnet_id                   = data.aws_subnets.subnets.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${data.aws_security_group.sg.id}"]

  user_data                   = data.template_file.user_data.rendered

  root_block_device {
    volume_type = "gp3"
    volume_size = var.volume_size

    tags = {
      Name = var.this_name
    }
  }
  
  tags = local.tags
}
