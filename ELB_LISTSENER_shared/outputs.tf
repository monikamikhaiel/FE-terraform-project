output "LISTENER_id" {
    value = flexibleengine_lb_listener_v3.basic.*.id
}
output "ELB_id" {
    value = flexibleengine_lb_loadbalancer_v3.basic.id
    }
output "pool_id" {
    value = flexibleengine_lb_pool_v2.pool_1.*.id
}
# output "whitelist_id" {
#     value = flexibleengine_lb_whitelist_v2.whitelist_1.*.id
# }
# output "monitor_id" {
#     value = flexibleengine_lb_monitor_v2.monitor_1.*.id
# }
# # output "pool_id" {
# #     value = flexibleengine_lb_monitor_v2.monitor_1
# # }