provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "sanitech_notifications" {
  name = "sanitech-notifications"
}

resource "aws_sns_topic_subscription" "sanitech_admin_notifications" {
  topic_arn = aws_sns_topic.sanitech_notifications.arn
  protocol  = "email"
  endpoint  = "admin@example.com"
}

resource "aws_sns_topic_subscription" "sanitech_user_notifications" {
  topic_arn = aws_sns_topic.sanitech_notifications.arn
  protocol  = "sms"
  endpoint  = "+1234567890"
}

resource "aws_cloudwatch_event_rule" "sanitech_system_health_check" {
  name        = "sanitech-system-health-check"
  description = "Trigger a notification when the system health check fails"

  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "sanitech_system_health_check_target" {
  rule      = aws_cloudwatch_event_rule.sanitech_system_health_check.name
  target_id = "sanitech-system-health-check-target"
  arn       = aws_lambda_function.sanitech_system_health_check.arn
}

resource "aws_lambda_permission" "sanitech_system_health_check_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sanitech_system_health_check.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sanitech_system_health_check.arn
}

resource "aws_lambda_function" "sanitech_system_health_check" {
  function_name = "sanitech-system-health-check"
  runtime       = "python3.8"
  role          = aws_iam_role.sanitech_system_health_check.arn
  handler       = "health_check.lambda_handler"
  source_code_hash = filebase64sha256("health_check.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.sanitech_notifications.arn
    }
  }
}

resource "aws_iam_role" "sanitech_system_health_check" {
  name = "sanitech-system-health-check"

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

resource "aws_iam_role_policy_attachment" "sanitech_system_health_check_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sanitech_system_health_check.name
}
