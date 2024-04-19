resource "aws_autoscaling_schedule" "sanitech_maintenance_window" {
  scheduled_action_name  = "sanitech-maintenance-window"
  min_size              = 0
  max_size              = 0
  desired_capacity       = 0
  recurrence            = "0 0 * * 1" # Run every Monday at midnight
  autoscaling_group_name = aws_autoscaling_group.sanitech.name
}

resource "aws_lambda_permission" "sanitech_maintenance_permission" {
  statement_id  = "AllowExecutionFromScheduledRule"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sanitech_maintenance.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.sanitech_maintenance.arn
}

resource "aws_sns_topic_subscription" "sanitech_maintenance_subscription" {
  topic_arn = aws_sns_topic.sanitech_maintenance.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sanitech_maintenance.arn
}

resource "aws_lambda_function" "sanitech_maintenance" {
  filename         = "maintenance.zip"
  function_name    = "sanitech-maintenance"
  role             = aws_iam_role.sanitech_maintenance.arn
  handler          = "maintenance.handler"
  source_code_hash = filebase64sha256("maintenance.zip")
  runtime          = "nodejs14.x"
}

resource "aws_iam_role" "sanitech_maintenance" {
  name = "sanitech-maintenance"

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

resource "aws_iam_role_policy_attachment" "sanitech_maintenance_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sanitech_maintenance.name
}

resource "aws_sns_topic" "sanitech_maintenance" {
  name = "sanitech-maintenance"
}
