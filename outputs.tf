output "rest_api_id" {
  description = "The ID of the REST API."
  value       = module.rest_api.rest_api_id
}

output "stage_name" {
  description = "The name of the deployment stage."
  value       = module.rest_api.stage_name
}

output "stage_arn" {
  description = "The execution ARN of the REST API stage, used e.g. for associating a custom WAF Web ACL."
  value       = module.rest_api.stage_arn
}
