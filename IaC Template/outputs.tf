output "vpc_id" {
  value = module.vpc.vpc_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "public_subnet_ids" {
  value = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnet.private_subnet_ids
}

output "nat_gateway_ids" {
  value = module.nat_gw.nat_gateway_ids
}

output "public_route_table_id" {
  value = module.router.public_route_table_id
}

output "private_route_tables_ids" {
  value = module.router.private_route_tables_ids
}
