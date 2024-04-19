provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "sanitech_water_purification" {
  function_name = "sanitech-water-purification"

  filename      = "water_purification.zip"
  source_code_hash = filebase64sha256("water_purification.zip")
  handler       = "water_purification.lambda_handler"

  runtime = "python3.8"

  role = aws_iam_role.sanitech_lambda.arn

  environment {
    variables = {
      WATER_PUMP_PIN = "12"
      WATER_SENSOR_PIN = "13"
    }
  }

  vpc_config {
    subnet_ids = [aws_subnet.sanitech_private.id]
    security_group_ids = [aws_security_group.sanitech_lambda.id]
  }
}

resource "aws_lambda_function" "sanitech_waste_management" {
  function_name = "sanitech-waste-management"

  filename      = "waste_management.zip"
  source_code_hash = filebase64sha256("waste_management.zip")
  handler       = "waste_management.lambda_handler"

  runtime = "python3.8"

  role = aws_iam_role.sanitech_lambda.arn

  environment {
    variables = {
      WASTE_BIN_SENSOR_PIN = "14"
      WASTE_COMPACTOR_PIN = "15"
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
