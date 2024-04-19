provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_dashboard" "sanitech_monitoring_dashboard" {
  dashboard_name = "Sanitech Monitoring Dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "i-0123456789abcdef0"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "EC2 Instance CPU Utilization"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "NetworkPacketsIn",
            "InstanceId",
            "i-0123456789abcdef0"
          ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "us-east-1",
        "title": "EC2 Instance Network Packets In"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 14,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "NetworkPacketsOut",
            "InstanceId",
            "i-0123456789abcdef0"
          ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "us-east-1",
        "title": "EC2 Instance Network Packets Out"
      }
    }
  ]
}
EOF
}

resource "aws_cloudwatch_alarm" "sanitech_ec2_cpu_utilization_high" {
  alarm_name          = "SanitechEC2CPUTilizationHigh"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors the CPU utilization of the SaniTech EC2 instance and sends an alert when the average CPU utilization is greater than or equal to 80% for 5 minutes."
  alarm_actions       = [aws_sns_topic.sanitech_notifications.arn]
}

resource "aws_sns_topic" "sanitech_notifications" {
  name = "SanitechNotifications"
}

resource "aws_sns_topic_subscription" "sanitech_admin_notifications" {
  topic_arn = aws_sns_topic.sanitech_notifications.arn
  protocol  = "email"
  endpoint  = "admin@example.com"
}
