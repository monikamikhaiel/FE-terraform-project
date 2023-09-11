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
# create new vpc 
# resource "flexibleengine_vpc_v1" "example" {
#   name = var.vpc_name
#   cidr = "192.168.0.0/16"
# }
# resource "flexibleengine_vpc_subnet_v1" "subnet_with_tags" {
#   name       = var.subnet_name
#   cidr       = "192.168.199.0/24"
#   gateway_ip = "192.168.199.1"
#   vpc_id     = flexibleengine_vpc_v1.example.id

#   tags = {
#     source = "tf"
#   }
# }
data "flexibleengine_vpc_v1" "vpc" {
  name = "${var.vpc_name}"
}
# filter subnet by name
data "flexibleengine_vpc_subnet_v1" "subnet_v1" {
  name   = var.subnet_name
  vpc_id=data.flexibleengine_vpc_v1.vpc.id
 }
