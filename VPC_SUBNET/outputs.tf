output "vpc_id" {
   value = data.flexibleengine_vpc_v1.vpc.id
}
output "subnet_id" {
   value = data.flexibleengine_vpc_subnet_v1.subnet_v1.id
}
output "subnet_id_openstack" {
    value = data.flexibleengine_vpc_subnet_v1.subnet_v1.subnet_id
}
# output "subnet_id_openstack" {
#     value = flexibleengine_vpc_subnet_v1.subnet_with_tags.subnet_id
# }
# output "subnet_id" {
#     value = flexibleengine_vpc_subnet_v1.subnet_with_tags.id
# }
# output "vpc_id" {
#     value = flexibleengine_vpc_v1.vpc.id
# }