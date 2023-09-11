variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "domain_name" {}
variable "Listener_name" {}
variable "ELB_name" {}
variable "vpc_id" {}
variable "subnet_id" {}
# variable "server_certificate_id_https" {}
# variable "certificate_name" {}
variable "listener_protocol_v3" {type=list}
variable "listener_port_v3" {type=list}
variable "pool_protocol_v3" {type=list}
variable "name_regex_ecs" {type=list}
variable "member_port_v3" {type=list}
variable "pool_name"{type=list}
variable "cert_id" {}