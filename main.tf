locals {
  shared_config = nonsensitive(jsondecode(data.aws_ssm_parameter.shared_config.value))
}

module "general_rest_api_module" {
  source = "github.com/nsbno/terraform-aws-rest-api?ref=rest-api"

  name = var.service_name

  endpoint_type = "REGIONAL"

  redeployment_triggers = merge(
    { resource_proxy_id = module.api_proxy_addon_module.recource_proxy_id },
    { http_method       = module.api_proxy_addon_module.http_method },
    { integration_id    = aws_api_gateway_integration.rest_service.id },
    { type              = aws_api_gateway_integration.rest_service.type },
    { uri               = aws_api_gateway_integration.rest_service.uri },
    { connection_type   = aws_api_gateway_integration.rest_service.connection_type },
    aws_api_gateway_integration.rest_service.request_parameters
    # aws_apigatewayv2_api_mapping ?
  )
}
module "api_proxy_addon_module" {
  source = "github.com/nsbno/terraform-aws-rest-api//modules/proxy-api?ref=rest-api"

  rest_api_id = module.general_rest_api_module.rest_api_id
  parent_id   = module.general_rest_api_module.root_resource_id
  method_authorization = "NONE"
}

resource "aws_api_gateway_integration" "rest_service" {
  rest_api_id             = module.general_rest_api_module.rest_api_id
  resource_id             = module.api_proxy_addon_module.recource_proxy_id
  http_method             = module.api_proxy_addon_module.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "https://${var.service_name}.${data.aws_route53_zone.internal_vydev_io_zone_name.name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = data.aws_ssm_parameter.apigw_vpc_link_id.value
  integration_target      = local.shared_config.lb_internal_arn

  request_parameters = {
    "integration.request.path.proxy"  = "method.request.path.proxy"
    "integration.request.header.host" = "'${var.service_name}.${data.aws_route53_zone.internal_vydev_io_zone_name.name}'"
  }
}

resource "aws_apigatewayv2_api_mapping" "service" {
  api_id      = module.general_rest_api_module.rest_api_id
  # domain_name = var.migrate_to_rest_api ? aws_apigatewayv2_domain_name.apigw.id : aws_api_gateway_domain_name.rest_apigw.domain_name
  domain_name = data.aws_ssm_parameter.apigw_domain_name_id.value
  stage       = module.general_rest_api_module.stage_name
  api_mapping_key   = "services/${var.service_name}"
}

resource "aws_wafv2_web_acl_association" "rest_service" {
  # resource_arn = aws_api_gateway_stage.rest_service.arn
  resource_arn = module.general_rest_api_module.stage_arn
  web_acl_arn  = data.aws_ssm_parameter.rest_api_waf_arn.value
}




# resource "aws_api_gateway_deployment" "rest_service" {
#   rest_api_id = aws_api_gateway_rest_api.rest_service.id

#   triggers = {
#     redeployment = sha1(jsonencode([
#       aws_api_gateway_resource.rest_service_proxy.id,
#       aws_api_gateway_resource.rest_service_proxy.path_part,
#       aws_api_gateway_method.rest_service_any.id,
#       aws_api_gateway_method.rest_service_any.http_method,
#       aws_api_gateway_method.rest_service_any.request_parameters,
#       aws_api_gateway_integration.rest_service.id,
#       aws_api_gateway_integration.rest_service.type,
#       aws_api_gateway_integration.rest_service.uri,
#       aws_api_gateway_integration.rest_service.connection_type,
#       aws_api_gateway_integration.rest_service.request_parameters,
#     ]))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   depends_on = [aws_api_gateway_integration.rest_service]
# }

