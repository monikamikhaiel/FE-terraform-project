# # provider.tf
terraform {
  required_version = ">= 0.13"

  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine",
      version = ">= 1.20.0"
    }
  }
}
data "flexibleengine_compute_instances" "demo" {
  name = var.name_regex_ecs
}

resource "flexibleengine_lb_member_v2" "member_1" {
  #count = var.num_members
  count=length(data.flexibleengine_compute_instances.demo.instances)
  address       = data.flexibleengine_compute_instances.demo.instances[count.index].network[0].fixed_ip_v4
  protocol_port = var.member_port_v2
  pool_id       = var.pool_id
  #subnet_id     = module.ECS_backend_servers.subnet_id_openstack
  subnet_id = var.subnet_id
  # tags={source="tf"}

}