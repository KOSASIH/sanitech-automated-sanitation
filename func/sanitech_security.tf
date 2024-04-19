provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "sanitech_data_encryption" {
  description = "Data encryption key for SaniTech"
}

resource "aws_s3_bucket" "sanitech_telemetry_data" {
  bucket = "sanitech-telemetry-data"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.sanitech_data_encryption.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "sanitech_telemetry_data" {
  bucket = aws_s3_bucket.sanitech_telemetry_data.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.sanitech_telemetry_data.arn}/*"
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "10.0.0.0/8"
          }
        }
      }
    ]
  })
}

resource "aws_security_group" "sanitech_api" {
  name_prefix = "sanitech-api"

  vpc_id = aws_vpc.sanitech.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "sanitech_api" {
  name            = "sanitech-api"
  internal        = false
  security_groups = [aws_security_group.sanitech_api.id]
  subnets         = aws_subnet.sanitech_public.*.id
}

resource "aws_alb_listener" "sanitech_api" {
  load_balancer_arn = aws_alb.sanitech_api.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/abcdefgh-1234-1234-1234-abcdefghijkl"

  default_action {
    target_group_arn = aws_alb_target_group.sanitech_api.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "sanitech_api" {
  name     = "sanitech-api"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sanitech.id

  health_check {
    path = "/healthz"
  }
}

resource "aws_alb_target_group_attachment" "sanitech_api" {
  target_group_arn = aws_alb_target_group.sanitech_api.arn
  target_id        = aws_instance.sanitech_api.id
  port             = 80
}

resource "aws_instance" "sanitech_api" {
  ami= "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.sanitech_api.id
  ]

  subnet_id = aws_subnet.sanitech_public.*.id[0]
}
