locals {
  shared_config = nonsensitive(jsondecode(data.aws_ssm_parameter.shared_config.value))

  internal_domain_name = "${var.service_name}.${local.shared_config.internal_hosted_zone_name}"
  api_gateway_path     = coalesce(var.custom_api_gateway_path, var.service_name)
}

module "rest_api" {
  source = "github.com/nsbno/terraform-aws-rest-api?ref=1.0.0"

  name          = var.service_name
  endpoint_type = "REGIONAL"
  redeployment_triggers = jsonencode({
    proxy = module.api_proxy_addon
  })
}
module "api_proxy_addon" {
  source = "github.com/nsbno/terraform-aws-rest-api//modules/proxy-api?ref=1.0.0"

  rest_api_id        = module.rest_api.rest_api_id
  parent_id          = module.rest_api.root_resource_id
  authorization_type = "NONE"


  load_balancer_integration = {
    load_balancer_arn    = local.shared_config.lb_internal_arn,
    connection_id        = data.aws_ssm_parameter.apigw_vpc_link_id.value,
    backend_uri_template = "https://${var.service_name}.${data.aws_route53_zone.internal_vydev_io_zone_name.name}/{proxy}"
    request_parameters = {
      "integration.request.path.proxy"  = "method.request.path.proxy"
      "integration.request.header.host" = "'${var.service_name}.${data.aws_route53_zone.internal_vydev_io_zone_name.name}'"
    }
  }
}

resource "aws_apigatewayv2_api_mapping" "service" {
  api_id          = module.rest_api.rest_api_id
  domain_name     = data.aws_ssm_parameter.apigw_domain_name_id.value
  stage           = module.rest_api.stage_name
  api_mapping_key = "services/${local.api_gateway_path}/*"
}

resource "aws_wafv2_web_acl_association" "rest_service" {
  count = var.waf_enabled ? 1 : 0

  resource_arn = module.rest_api.stage_arn
  web_acl_arn  = data.aws_ssm_parameter.rest_api_waf_arn.value
}
