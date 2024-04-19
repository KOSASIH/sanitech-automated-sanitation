provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_group" "sanitech_optimization" {
  name                 = "sanitech-optimization"
  launch_configuration = aws_launch_configuration.sanitech_optimization.name
  min_size             = 1
  max_size             = 10
  desired_capacity     = 3
  health_check_type    = "EC2"
  health_check_grace_period = 300
  force_delete        = true
  vpc_zone_identifier  = aws_subnet.sanitech_private[*].id

  tag {
    key                 = "Name"
    value               = "sanitech-optimization"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "production"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "sanitech_optimization" {
  name_prefix          = "sanitech-optimization-"
  image_id             = "ami-0c94855ba95c574c8"
  instance_type        = "t3.micro"
  key_name             = "sanitech-key"
  security_groups      = [aws_security_group.sanitech_optimization.id]
  user_data            = filebase64("user-data.sh")
  iam_instance_profile = aws_iam_instance_profile.sanitech_optimization.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "sanitech_optimization" {
  name_prefix = "sanitech-optimization-"
  role        = aws_iam_role.sanitech_optimization.name
}

resource "aws_iam_role" "sanitech_optimization" {
  name_prefix = "sanitech-optimization-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sanitech_optimization" {
  policy_arn = "arn:aws:iam::aws:policy/service-associate-autoscaling"
  role       = aws_iam_role.sanitech_optimization.name
}

resource "aws_security_group" "sanitech_optimization" {
  name_prefix = "sanitech-optimization-"

  vpc_id = aws_vpc.sanitech.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_metric_alarm" "sanitech_optimization_cpu_utilization" {
  alarm_name          = "sanitech-optimization-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  alarm_description = "This metric monitors the CPU utilization of the SaniTech Optimization instances and sends an alert when the average CPUutilization is greater than or equal to 80% for 1 minute."

  alarm_actions = [aws_autoscaling_policy.sanitech_optimization_scale_up.arn]
}

resource "aws_autoscaling_policy" "sanitech_optimization_scale_up" {
  name                   = "sanitech-optimization-scale-up"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = aws_autoscaling_group.sanitech_optimization.name
}

resource "aws_cloudwatch_metric_alarm" "sanitech_optimization_memory_utilization" {
  alarm_name          = "sanitech-optimization-memory-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  alarm_description = "This metric monitors the memory utilization of the SaniTech Optimization instances and sends an alert when the average memory utilization is greater than or equal to 80% for 1 minute."

  alarm_actions = [aws_autoscaling_policy.sanitech_optimization_scale_down.arn]
}

resource "aws_autoscaling_policy" "sanitech_optimization_scale_down" {
  name                   = "sanitech-optimization-scale-down"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = aws_autoscaling_group.sanitech_optimization.name
}
