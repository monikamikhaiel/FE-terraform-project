Languages : Terraform 
Platorm : Flexile Engine -> https://registry.terraform.io/providers/FlexibleEngineCloud/flexibleengine/latest
this project is for creating LoadBalancers on FlexibleEngine Cloud along with provisionning EIP and attaching them with it 
filling the variable will create 2 ELBs along with their listeners sever groups whitelist certificat VPC and subnet 
one ELB is shared and the other is dedicated both may share v2 server groups 
## what are the prerequites ?


having the ECS ready with the application running on them along with the security group configuartion done 
## what are the input parameters that needs modification ? 
a. the main variables which are : ak-sk-domain_name-region 

b. Certificat name  generated from its module "CERTIFICAT_NAME" 

c. subnet, vpc names where all the resources are created whether they are already created or will be created "SUBNET_NAME" and "VPC_NAME" 

d. ELB name  and its liseners that will be created "ELB_NAME" and "LISTENER_NAME_X" 

e. the listener port and protocol "PORT_OF_LISTENER_OF_SERVER_GROUP_X" and "PORTOCOL_OF_LISTENER_OF_SERVER_GROUP_X"

f. the backend ports and protocols "PORT_OF_MEMBER_OF_SERVER_GROUP_X" and "PORTOCOL_OF_SERVER_GROUP_X"

g. the regex of the ECS names that will be included in each server goup / pool "REGEX_OF_BACKEND_MEMBERS_JOINING_SERVER_GROUP_X"

h. Whitelist is only available for v2 ELB whether to enable/disable if it is disable then put the respective witelist empty ""
