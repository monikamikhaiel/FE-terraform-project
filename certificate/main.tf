# openssl.exe req -new -key yourcertname.key -out yourcertname.csr
# terraform {
#   required_providers {
#     tls = {
#       source = "hashicorp/tls"
#       version = "4.0.1"
#     }
#   }
# }
terraform {
  required_version = ">= 0.13"

  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine",
      version = ">= 1.20.0"
    }
  }
}
provider "tls" {
  # Configuration options
}
# provider "flexibleengine" {
#   region      = var.region
#   access_key  = var.access_key
#   secret_key  = var.secret_key
#   domain_name = var.domain_name
#   }
# generate key with Hashcorp resource 
# RSA key of size 4096 bits
# resource "tls_private_key" "rsa-4096-example" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
# resource "tls_cert_request" "example" {
#   # private_key_pem = file("private_key.pem")
#     private_key_pem = tls_private_key.rsa-4096-example.private_key_openssh
# }
# # output "tls_private_key"{
# #   value=tls_private_key.rsa-4096-example.private_key_openssh
# #   sensitive = true
# # }
resource "flexibleengine_elb_certificate" "certificate_1" {
  name        = var.certificate_name
  description = "terraform test certificate"
  # domain      = "www.elb.com"
  # private_key = tls_private_key.rsa-4096-example.private_key_openssh
  certificate = file(var.certificat_path)
}
output "cert_id" {
  value=flexibleengine_elb_certificate.certificate_1.id
}