module "api_gateway" {
  source = "../../../../modules/api_gateway"

  name        = var.name
  description = var.description
  stage_name  = var.stage_name
  variables   = var.variables
}

# Output the API Gateway endpoint URL
output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}
