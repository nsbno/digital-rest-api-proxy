variable "service_name" {
  type = string
  description = "Name of the service used in the API gateway service path. Your service will be avaialable at /services/<service_name>"
}

variable "custom_api_gateway_path" {
  type        = string
  default     = null
  description = "By default, your service will be avaialable at /services/<service_name>. If you set this variable, it will be available at /services/<custom_api_gateway_path> intead."
}