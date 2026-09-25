variable "service_name" {
  type        = string
  description = "Name of the service used in the API gateway service path. Your service will be avaialable at /services/<service_name>"
}

variable "custom_api_gateway_path" {
  type        = string
  default     = null
  description = "By default, your service will be avaialable at /services/<service_name>. If you set this variable, it will be available at /services/<custom_api_gateway_path> intead."
}

variable "waf_enabled" {
  type        = bool
  default     = true
  description = "By default, WAF keeps the API private and only reachable from CloudFront and main-frontend. Disabling it makes the endpoint publicly available and more vulnerable to DoS attacks."
}

variable "binary_media_types" {
  description = "MIME types that API Gateway should treat as binary data."
  type        = list(string)
  default     = []
}

variable "method_request_parameters" {
  description = "Request parameters to be passed from the method request to the integration request."
  type        = map(bool)
  default = {
    "method.request.path.proxy"  = true
    "method.request.header.host" = true
  }
}

variable "integration_request_parameters" {
  description = "Request parameters to be passed from the integration request to the backend."
  type        = map(string)
}