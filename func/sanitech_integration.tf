provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "sanitech_weather_alerts" {
  name = "sanitech-weather-alerts"
}

resource "aws_sns_topic_subscription" "sanitech_emergency_response" {
  topic_arn = aws_sns_topic.sanitech_weather_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sanitech_emergency_response.arn
}

resource "aws_lambda_function" "sanitech_emergency_response" {
  function_name = "sanitech-emergency-response"

  filename      = "emergency_response.zip"
  source_code_hash = filebase64sha256("emergency_response.zip")
  handler       = "emergency_response.lambda_handler"

  runtime = "python3.8"

  role = aws_iam_role.sanitech_lambda.arn

  environment {
    variables = {
      WEATHER_ALERTS_TOPIC = aws_sns_topic.sanitech_weather_alerts.arn
    }
  }

  vpc_config {
    subnet_ids = [aws_subnet.sanitech_private.id]
    security_group_ids = [aws_security_group.sanitech_lambda.id]
  }
}

resource "aws_iam_role" "sanitech_lambda" {
  name = "sanitech-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sanitech_lambda_basic_execution" {
  role       = aws_iam_role.sanitech_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_subnet" "sanitech_private" {
  vpc_id     = aws_vpc.sanitech.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "sanitech_lambda" {
  name_prefix = "sanitech-lambda"

  vpc_id = aws_vpc.sanitech.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_sns_topic_subscription" "sanitech_weather_forecast" {
  topic_arn = aws_sns_topic.sanitech_weather_alerts.arn
  protocol  = "http"
  endpoint  = "https://example.com/weather-forecast"
}
