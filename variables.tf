variable "service_name" {
    type = string     
}

# variable "hosted_zone_name" {
#     type = string
# }

# variable "alb_arn" {
#     type = string
# }

variable "custom_api_gateway_path" {
  type        = string
  default     = null
  description = "By default, your service will be avaialable at /services/<name>. If you set this variable, it will be available at /services/<custom_api_gateway_path> intead."
}