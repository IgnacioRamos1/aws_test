# Crea la API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = var.name
}

# Crea un modelo de respuesta para la API Gateway
resource "aws_api_gateway_model" "response" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  name        = "Response"
  content_type = "application/json"

  schema = jsonencode({
    "type"       : "object",
    "properties" : {
      "message" : { "type" : "string" }
    }
  })
}

# Crea un recurso raíz
resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = var.root_resource_path
}

# Crea un método HTTP
resource "aws_api_gateway_method" "http_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = var.http_method
  authorization = var.authorization
}

# Crea una integración con la Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.root_resource.id
  http_method = aws_api_gateway_method.http_method.http_method

  integration_http_method = "POST"

  uri = aws_lambda_function.lambda.arn
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = jsonencode({
      "statusCode" : "200",
    })
  }
}

# Crea una respuesta HTTP
resource "aws_api_gateway_method_response" "http_response" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.root_resource.id
  http_method = aws_api_gateway_method.http_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = aws_api_gateway_model.response.id
  }
}

# Crea una respuesta de integración
resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.root_resource.id
  http_method = aws_api_gateway_method.http_method.http_method
  status_code = "200"

  response_templates = {
    "application/json" = jsonencode({
      "message" : "$input.path('$.message')"
    })
  }
}

# Crea el deployment
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = var.stage_name
}
