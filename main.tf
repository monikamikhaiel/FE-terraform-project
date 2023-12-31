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
## creating a new certificat 
module "CERTIFICAT_MODULE_NAME" {
  source="./certificate"
  certificate_name= CERTIFICAT_NAME # the name of the newly created certificat
  certificat_path="./certificate.pem" # .PEM file path the one generated by the module

}
module "VPC_SUBNET_MODULE_NAME" {
  source="./VPC_SUBNET"
  region      = var.region
  access_key  = var.access_key
  secret_key  = var.secret_key
  domain_name = var.domain_name
  vpc_name= VPC_NAME # the name of the newly created VPC 
  subnet_name= SUBNET_NAME # the name of the newly created subnet inside this VPC  

}

module "ELB_LISTENER_POOL_V3" {
  source="./ELB_LISTSENER_shared"
  region      = var.region
  access_key  = var.access_key
  secret_key  = var.secret_key
  domain_name = var.domain_name
  ELB_name= ELB_NAME
  Listener_name= [LISTENER_NAME_1,LISTENER_NAME_2,...]
  vpc_id    = module.VPC_SUBNET_MODULE_NAME.vpc_id
  subnet_id=module.VPC_SUBNET_MODULE_NAME.subnet_id_openstack
  cert_id=module.CERTIFICAT_MODULE_NAME.cert_id
  whitelist=["","XXX.XXX.XXX.XXX/XX",....] ## adding whitelist to the listeners "" means all  or just adding the subnet -> "XX.XX.XX.XX/XX"
  enable_whitelist=[false,true] ## true or false 
  listener_protocol_v2=[PORTOCOL_OF_LISTENER_OF_SERVER_GROUP_1,PORTOCOL_OF_LISTENER_OF_SERVER_GROUP_2,....]
  listener_port_v2=[PORTOCOL_OF_LISTENER_OF_SERVER_GROUP_1,PORTOCOL_OF_LISTENER_OF_SERVER_GROUP_2,....]
  pool_protocol_v2=[PORTOCOL_OF_SERVER_GROUP_1,PORTOCOL_OF_SERVER_GROUP_2,....]
  name_regex_ecs=["*"REGEX_OF_BACKEND_MEMBERS_JOINING_SERVER_GROUP_1,"*|*"REGEX_OF_BACKEND_MEMBERS_JOINING_SERVER_GROUP_2,.....]
  #num_members=var.num_members
  member_port_v2=[PORT_OF_MEMBER_OF_SERVER_GROUP_1,PORT_OF_MEMBER_OF_SERVER_GROUP_2,......]
  pool_name=[SERVER_GROUP_NAME_1,SERVER_GROUP_NAME_2,....]
}
module "ELB_LISTENER_POOL_V2" {
  source="./ELB_LISTSENER"
  region      = var.region
  access_key  = var.access_key
  secret_key  = var.secret_key
  domain_name = var.domain_name
  ELB_name= ELB_NAME
  Listener_name= [LISTENER_NAME_1,LISTENER_NAME_2,...]
  vpc_id    = module.VPC_SUBNET_MODULE_NAME.vpc_id
  subnet_id=module.VPC_SUBNET_MODULE_NAME.subnet_id_openstack
  listener_protocol_v3=[PORTOCOL_OF_LISTENER_OF_SERVER_GROUP_1,PORTOCOL_OF_LISTENER_OF_SERVER_GROUP_2,....]
  listener_port_v3=[PORT_OF_LISTENER_OF_SERVER_GROUP_1,PORT_OF_LISTENER_OF_SERVER_GROUP_2,....]
  cert_id=module.CERTIFICAT_MODULE_NAME.cert_id
  pool_protocol_v3=[PORTOCOL_OF_SERVER_GROUP_1,PORTOCOL_OF_SERVER_GROUP_2,....]
  name_regex_ecs=["*"REGEX_OF_BACKEND_MEMBERS_JOINING_SERVER_GROUP_1,"*|*"REGEX_OF_BACKEND_MEMBERS_JOINING_SERVER_GROUP_2] #these VMS should be ready before running the script 
  member_port_v3= [PORT_OF_MEMBER_OF_SERVER_GROUP_1,PORT_OF_MEMBER_OF_SERVER_GROUP_2,......] # these are the backend ports supposedly all the memebers share the same port 
  pool_name=[SERVER_GROUP_NAME_1,SERVER_GROUP_NAME_2,....] # these server groups will be created part of the module 
}
