resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample2"
  description = "Terraform Serverless Application Example"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.example.invoke_url}"
}
