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
resource "flexibleengine_lb_loadbalancer_v3" "basic" {
  name              = var.ELB_name
  description       = "tf source" 
  # cross_vpc_backend = true associate the IP addresses of backend servers with your load balancer

  vpc_id            = var.vpc_id
  # ipv6_network_id   = "{{ ipv6_network_id }}"
  # ipv6_bandwidth_id = "{{ ipv6_bandwidth_id }}"
  ipv4_subnet_id    = var.subnet_id

  # l4_flavor_id = "{{ l4_flavor_id }}"
  # l7_flavor_id = "{{ l7_flavor_id }}"

  availability_zone = [
    "eu-west-0a",
    "eu-west-0b",
  ]

  iptype                = "5_bgp"
  bandwidth_charge_mode = "traffic"
  sharetype             = "PER"
  bandwidth_size        = 10
  tags={source="tf"}

}
resource "flexibleengine_lb_listener_v3" "basic" {
  count = length(var.Listener_name)
  name            = var.Listener_name[count.index]
  description     = "basic description for totem"
  protocol        = var.listener_protocol_v3[count.index]
  protocol_port   = var.listener_port_v3[count.index]
  loadbalancer_id = flexibleengine_lb_loadbalancer_v3.basic.id

  # idle_timeout     = 60
  # request_timeout  = 60
  # response_timeout = 60

tags={source="tf"}
  server_certificate= var.cert_id
}
# data "flexibleengine_lb_certificate_v2" "test" {
#   name = var.certificate_name
# }
resource "flexibleengine_lb_pool_v2" "pool_1" {
  count = length(var.pool_protocol_v3)
  protocol    = var.pool_protocol_v3[count.index]
  lb_method   = "ROUND_ROBIN"
  listener_id = tolist(flexibleengine_lb_listener_v3.basic)[count.index].id
  # tags={source="tf"}
  name= var.pool_name[count.index]
}
# resource "flexibleengine_lb_whitelist_v2" "whitelist_1" {
#   enable_whitelist = true
#   whitelist        = var.whitelist
#   listener_id      = flexibleengine_lb_listener_v3.basic.id
# }


# resource "flexibleengine_lb_member_v2" "member_1" {
#   #count = var.num_members
#   count=length(data.flexibleengine_compute_instances.demo.instances)
#   address       = data.flexibleengine_compute_instances.demo.instances[count.index].network[0].fixed_ip_v4
#   protocol_port = var.member_port_v3
#   pool_id       = flexibleengine_lb_pool_v2.pool_1[].id
#   #subnet_id     = module.ECS_backend_servers.subnet_id_openstack
#   subnet_id = var.subnet_id
#   tags={source="tf"}
# }
# resource "flexibleengine_lb_monitor_v2" "monitor_1" {
#   count = length(var.pool_name)
#   pool_id     = tolist(flexibleengine_lb_pool_v2.pool_1)[count.index].id
#   type        = "PING"
#   delay       = 20
#   timeout     = 10
#   max_retries = 5
# }
module "add_members_gp" {
  source="../members_pool"
  # for_each= flexibleengine_lb_pool_v2.pool_1
  # pool_id=each.value.id
  count = length(flexibleengine_lb_pool_v2.pool_1)
  pool_id= tolist(flexibleengine_lb_pool_v2.pool_1)[count.index].id
  subnet_id=var.subnet_id
  name_regex_ecs  = var.name_regex_ecs[count.index]
  member_port_v2=var.member_port_v3[count.index]
  }
