output "vpc_name" {
	value = var.vpc_name
}
output "vpc_id" {
	value = data.aws_vpc.vpc.id
}
output "security_group"{
	value = var.sg_name
}
output "ec2_instance_type"{
	value = var.ec2_instance_type
}
output "aws_ami_id" {
	value = data.aws_ami.ami.id
}
output "ec2_public_ip" {
	value = aws_instance.ec2.public_ip
}
output "ec2_private_ip" {
	value = aws_instance.ec2.private_ip
}
output "ec2_keyname"{
	value = var.key_name
}
output "default_ec2_keypair_if_keyname_undefined"{
	value = var.aws_key_name[var.aws_region]
}
output "user_data" {
	value = data.template_file.user_data.rendered
}
