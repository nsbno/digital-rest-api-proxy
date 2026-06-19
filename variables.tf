variable "service_name" {
  type = string
  description = "Name of the service used in the API gateway service path. Your service will be avaialable at /services/<service_name>"
}

variable "custom_api_gateway_path" {
  type        = string
  default     = null
  description = "By default, your service will be avaialable at /services/<service_name>. If you set this variable, it will be available at /services/<custom_api_gateway_path> intead."
}

variable "waf_enabled" {
  type = bool
  default = true
  description = "By default, WAF keeps the API private and only reachable from CloudFront and main-frontend. Disabling it makes the endpoint publicly available and more vulnerable to DoS attacks."
}