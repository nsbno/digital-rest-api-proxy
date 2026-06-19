data "aws_ssm_parameter" "shared_config" {
  name = "/digitalekanaler/shared-config"
}

data "aws_ssm_parameter" "apigw_vpc_link_id" {
  name = "/digitalekanaler-microservices-api/vpc-link-id"
}

data "aws_ssm_parameter" "apigw_domain_name_id" {
  name = "/digitalekanaler-microservices-api/domain-name-id"
}

data "aws_ssm_parameter" "rest_api_waf_arn" {
  name = "/digitalekanaler-microservices-api/rest-api-waf-arn"
}

data "aws_lb" "internal_lb_arn" {
  arn = local.shared_config.lb_internal_arn
}

data "aws_route53_zone" "internal_vydev_io_zone_name" {
  name         = local.shared_config.internal_hosted_zone_name
  private_zone = true
}