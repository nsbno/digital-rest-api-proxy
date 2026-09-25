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
  default     = null
}

variable "response_transfer_mode" {
  description = "Set to STREAM to let the backend stream its response (e.g. Server-Sent Events) instead of API Gateway buffering it in full before returning. STREAM raises the allowed timeout_milliseconds ceiling from 29,000ms to 900,000ms without a service quota increase."
  type        = string
  default     = "BUFFERED"

  validation {
    condition     = contains(["BUFFERED", "STREAM"], var.response_transfer_mode)
    error_message = "response_transfer_mode must be BUFFERED or STREAM."
  }
}

variable "timeout_milliseconds" {
  description = "Integration timeout in milliseconds. Max 29,000 for BUFFERED (default; higher requires an AWS service quota increase), max 900,000 for STREAM."
  type        = number
  default     = 29000
}