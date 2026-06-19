# module "spring_boot_service" {
#   source                                = "github.com/nsbno/terraform-digitalekanaler-modules//spring-boot-service?ref=x.y.z"
#   name                                  = my-application-name
#   ...
# }

module "digital_rest_api_proxy" {
  source = "github.com/nsbno/digital-rest-api-proxy?ref=genesis"
  service_name = my-application-name
}