
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/hello-world"
  output_path = "${path.module}/hello-world.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#resource "aws_lambda_function" "lambda_functions" {
#  for_each         = var.lambdas
#  filename         = "hello-world.zip"
#  function_name    = each.value.name
#  role             = aws_iam_role.lambda_exec.arn
#  handler          = "index.handler"
#  source_code_hash = filebase64sha256("hello-world.zip")
#
#  runtime = "nodejs14.x"
#}

# Create the API gateway and resources

#resource "aws_api_gateway_rest_api" "api_gateway" {
#  name = var.api-gateway-name
#}

#resource "aws_api_gateway_resource" "resources" {
#  for_each    = var.lambdas
#  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
#  path_part   = each.value.path
#}

#resource "aws_api_gateway_method" "methods" {
#  for_each         = aws_api_gateway_resource.resources
#  rest_api_id      = aws_api_gateway_rest_api.api_gateway.id
#  resource_id      = each.value.id
#  http_method      = "POST"
#  authorization    = "NONE"
#  api_key_required = false
#}

#resource "aws_api_gateway_integration" "integration" {
#  for_each = aws_api_gateway_method.methods
#  rest_api_id             = each.value.rest_api_id
#  resource_id             = each.value.resource_id
#  http_method             = each.value.http_method
#  integration_http_method = "POST"
#  type                    = "AWS_PROXY"
#  uri                     = aws_lambda_function.lambda_functions[each.key].invoke_arn
#}