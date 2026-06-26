locals {
  application_name = "my-application-name"
}
# module "spring_boot_service" {
#   source                                = "github.com/nsbno/terraform-digitalekanaler-modules//spring-boot-service?ref=x.y.z"
#   name                                  = local.application_name
#   ...
# }

module "digital_rest_api_proxy" {
  source       = "github.com/nsbno/digital-rest-api-proxy?ref=1.0.0"
  service_name = local.application_name
}
