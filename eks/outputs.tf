output "vpc_id" {
	value = module.vpc.vpc_id
}
# output "rds_endpoint" {
# 	value = module.db.db_instance_address
# }
output "rds_instance_type" {
	value = var.rds_instance_type
}
output "rds_engine_version" {
	value = var.rds_engine_version
}
output "cluster_version" {
	value = var.cluster_version
}
