output "this_name" {
    value = var.this_name
}
output "vpc_id" {
	value = data.aws_vpc.vpc.id
}
output "rds_endpoint" {
	value = module.db.db_instance_address
}
output "rds_instance_type" {
	value = var.rds_instance_type
}
output "rds_engine_version" {
	value = var.rds_engine_version
}