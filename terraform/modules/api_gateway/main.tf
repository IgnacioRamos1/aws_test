resource "aws_api_gateway_rest_api" "lambda_api" {
  name = "olga-api"
}

resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part   = var.endpoint
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_api.id
  resource_id             = aws_api_gateway_resource.lambda_resource.id
  http_method             = var.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda.invoke_arn
}

resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_api.id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration_response" "integration_response" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.lambda_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  resource_id = aws_api_gateway_resource.lambda_resource.id
  http_method = aws_api_gateway_method.lambda_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_method.lambda_method,
    aws_api_gateway_resource.lambda_resource,
  ]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  stage_name  = "dev"
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/${aws_api_gateway_rest_api.lambda_api.id}/*"
}
