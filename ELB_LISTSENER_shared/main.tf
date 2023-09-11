# provider.tf
terraform {
  required_version = ">= 0.13"

  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine",
      version = ">= 1.20.0"
    }
  }
}

provider "flexibleengine" {
  region      = var.region
  access_key  = var.access_key
  secret_key  = var.secret_key
  domain_name = var.domain_name
  }
resource "flexibleengine_vpc_eip_v1" "eip_with_tags" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name       = "mybandwidth"
    size       = 10
    share_type = "PER"
  }
  tags = {source = "tf"}
}
resource "flexibleengine_lb_loadbalancer_v2" "basic" {
    name              = var.ELB_name
    description       = "tf source" 
  vip_subnet_id    = var.subnet_id
  # vip_address = flexibleengine_vpc_eip_v1.eip_with_tags.address
  tags={source="tf"}
}
# attach elb with eip 
# https://github.com/FlexibleEngineCloud/terraform-flexibleengine-elb/blob/master/main.tf
# resource "flexibleengine_networking_floatingip_v2" "loadbalancer_eip" {
#   # count      = var.bind_eip && var.eip_addr == null ? 1 : 0
#   pool       = "admin_external_net"
#   port_id    = flexibleengine_lb_loadbalancer_v2.basic.vip_port_id
#   depends_on = [flexibleengine_lb_loadbalancer_v2.basic]
# }
resource "flexibleengine_networking_floatingip_associate_v2" "loadbalancer_eip_attach" {
  # count       = length()
  floating_ip = flexibleengine_vpc_eip_v1.eip_with_tags.address
  port_id     = flexibleengine_lb_loadbalancer_v2.basic.vip_port_id
}

resource "flexibleengine_lb_listener_v2" "basic" {
  count=length(var.Listener_name)
  name            = var.Listener_name[count.index]
  description     = "basic description for totem"
  protocol        = var.listener_protocol_v2[count.index]
  protocol_port   = var.listener_port_v2[count.index]
  loadbalancer_id = flexibleengine_lb_loadbalancer_v2.basic.id

  # idle_timeout     = 60
  # request_timeout  = 60
  # response_timeout = 60

  tags = {key = "tf"}
  # default_tls_container_ref= data.flexibleengine_lb_certificate_v2.test.id
  default_tls_container_ref=var.cert_id
}
# data "flexibleengine_lb_certificate_v2" "test" {
#   name = var.certificate_name
#   # tags={source="tf"}

# }
resource "flexibleengine_lb_pool_v2" "pool_1" {
  count=length(var.pool_name)
  protocol    = var.pool_protocol_v2[count.index]
  lb_method   = "ROUND_ROBIN"
  listener_id = flexibleengine_lb_listener_v2.basic[count.index].id
  # tags={source="tf"}
  name= var.pool_name[count.index]

}
resource "flexibleengine_lb_whitelist_v2" "whitelist_1" {
  # count=var.whitelist[count.index]!= null? length(var.Listener_name) : 0
  for_each = { for whitelist in var.whitelist: whitelist => whitelist!=""}
  enable_whitelist = var.enable_whitelist[index(var.whitelist, each.key)]
  whitelist        = each.key
  listener_id      = flexibleengine_lb_listener_v2.basic[index(var.whitelist, each.key)
].id
  # tags={source="tf"}
}
# resource "flexibleengine_lb_monitor_v2" "monitor_1" {
#   count=length(var.pool_name)
#   pool_id     = tolist(flexibleengine_lb_pool_v2.pool_1)[count.index].id
#   type        = "PING"
#   delay       = 20
#   timeout     = 10
#   max_retries = 5
# }

# data "flexibleengine_compute_instances" "demo" {
#   count= length(flexibleengine_lb_pool_v2.pool_1)
#   name = var.name_regex_ecs[count.index]
#  }
# #  pools{pools=[for pool in flexibleengine_lb_pool_v2.pool_1 :{
# #   id=pool.id
# #  }]}
# #  member_port{member_port=[for member_port in var.member_port_v2 :{
# #   member_port=member_port
# #  }]}
# resource "flexibleengine_lb_member_v2" "member_1" {
#    count=length(data.flexibleengine_compute_instances.demo.instances)*length(var.member_port_v2)
#   #  for_each = {
#   #   for pool in pools.pools : "${subnet.network_key}.${subnet.subnet_key}" => subnet
#   # }
#   address       = data.flexibleengine_compute_instances.demo.instances[count.index].network[0].fixed_ip_v4
#   protocol_port = var.member_port
#   pool_id       = var.pool_id
#   #subnet_id     = module.ECS_backend_servers.subnet_id_openstack
#   subnet_id = var.subnet_id
#   tags={source="tf"}

# }
# resource "flexibleengine_lb_member_v2" "member_1" {
#   #count = var.num_members
#   count=length(data.flexibleengine_compute_instances.demo.instances)
#   address       = data.flexibleengine_compute_instances.demo.instances[count.index].network[0].fixed_ip_v4
#   protocol_port = var.member_port_v2
#   pool_id       = flexibleengine_lb_pool_v2.pool_1[count.index].id
#   #subnet_id     = module.ECS_backend_servers.subnet_id_openstack
#   subnet_id = var.subnet_id
#   tags={source="tf"}

# }
module "add_members_gp" {
  source="../members_pool"
  # for_each= flexibleengine_lb_pool_v2.pool_1
  # pool_id=each.value.id
  count = length(var.pool_name)
  pool_id= tolist(flexibleengine_lb_pool_v2.pool_1)[count.index].id
  subnet_id=var.subnet_id
  name_regex_ecs  = var.name_regex_ecs[count.index]
  member_port_v2=var.member_port_v2[count.index]

  }
