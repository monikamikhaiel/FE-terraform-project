# # output "subnet_id" {
# #     value = module.vpc_subnet.subnet_id
# # }
# # output "vpc_id" {
# #     value = module.vpc_subnet.vpc_id
# # }
# ### dedicated ELB 
# output "LISTENER_id" {
#     value = module.elb_listener_shared_ELB-siopmwr-dev.LISTENER_id
# }
# output "ELB_id" {
#     value = module.elb_listener_shared_ELB-siopmwr-dev.ELB_id
#     }
# output "pool_id" {
#     value = module.elb_listener_shared_ELB-siopmwr-dev.pool_id
# }
# output "whitelist_id" {
#     value = module.elb_listener_shared_ELB-siopmwr-dev.whitelist_id
# }
# # output "monitor_id" {
# #     value = module.elb_listener_shared_ELB-siopmwr-dev.monitor_id
# # }
# output "LISTENER_id_shared" {
#     value = module.elb_listener_ELB-apimgr-uat.LISTENER_id_shared
# }
# output "ELB_id_shared" {
#     value = module.elb_listener_ELB-apimgr-uat.ELB_id_shared
#     }
# output "pool_id_shared" {
#     value = module.elb_listener_ELB-apimgr-uat.pool_id_shared
# }
output "whitelist_id_shared" {
    value = module.elb_listener_ELB-apimgr-uat.*
}
# # output "monitor_id_shared" {
# #     value = module.elb_listener_ELB-apimgr-uat.monitor_id_shared
# # }