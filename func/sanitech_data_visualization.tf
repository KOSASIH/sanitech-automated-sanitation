provider "aws" {
  region = "us-east-1"
}

resource "aws_kinesis_firehose_delivery_stream" "sanitech_data_visualization" {
  name = "sanitech-data-visualization"

  destination = "elasticsearch"

  elasticsearch {
    domain_name = aws_elasticsearch_domain.sanitech_elasticsearch.domain_name
    index_name  = "sanitech-data-visualization"
    type_name   = "_doc"
    role_arn    = aws_iam_role.sanitech_firehose.arn
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_elasticsearch_domain" "sanitech_elasticsearch" {
  domain_name           = "sanitech-elasticsearch"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "r5.large.elasticsearch"
    instance_count = 2
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 20
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  node_to_node_encryption = true
  encryption_at_rest {
    enabled = true
  }

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Principal = {
          AWS = "*"
        }
        Action    = [
          "es:DescribeDomain",
          "es:DescribeElasticsearch",
          "es:ESHttpGet",
          "es:ESHttpHead",
          "es:ESHttpPost"
        ]
        Resource = "${aws_elasticsearch_domain.sanitech_elasticsearch.arn}/*"
      }
    ]
  })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "sanitech_firehose" {
  name = "sanitech-firehose"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonKinesisFirehoseDeliveryRole",
    "arn:aws:iam::aws:policy/AmazonElasticsearchServiceFullAccess",
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_vpc" "sanitech" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sanitech-vpc"
  }
}

resource "aws_subnet" "sanitech_private" {
  vpc_id     = aws_vpc.sanitech.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sanitech-private-subnet"
  }
}

resource "aws_security_group" "sanitech_data_visualization" {
  name_prefix = "sanitech-data-visualization-"

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

resource "aws_kinesis_stream" "sanitech_data_visualization" {
  name = "sanitech-data-visualization"

  shard_count = 1

  tags = {
    Name = "sanitech-data-visualization"
  }
}

resource "aws_lambda_function" "sanitech_data_visualization" {
  function_name = "sanitech-data-visualization"

  runtime = "python3.8"

  role = aws_iam_role.sanitech_data_visualization.arn

  handler = "lambda.handler"

  filename = "lambda.zip"

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.sanitech_data_visualization.name
    }
  }
}

resource "aws_iam_role" "sanitech_data_visualization" {
  name = "sanitech-data-visualization"

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

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonKinesisReadOnlyAccess",
  ]

  inline_policy {
    name = "kinesis_stream_write"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "kinesis:PutRecord"
          Resource = aws_kinesis_stream.sanitech_data_visualization.arn
        }
      ]
    })
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kinesis_analytics_application" "sanitech_data_visualization" {
  name = "sanitech-data-visualization"

  input {
    name_prefix = "sanitech-data-visualization-"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.sanitech_data_visualization.arn
      role_arn     = aws_iam_role.sanitech_data_visualization.arn
    }

    schema {
      record_format {
        record_format_type = "CSV"
      }

      record_columns {
        name = "value"
        mapping = "value"
        sql_type = "VARCHAR(100)"
      }

      record_columns {
        name = "timestamp"
        mapping = "timestamp"
        sql_type = "TIMESTAMP"
      }
    }
  }

  output {
    name = "sanitech-data-visualization-output"

    kinesis_firehose {
      resource_arn = aws_kinesis_firehose_delivery_stream.sanitech_data_visualization.arn
      role_arn     = aws_iam_role.sanitech_firehose.arn
    }

    schema {
      record_format_type = "CSV"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_glue_catalog_database" "sanitech_data_visualization" {
  name = "sanitech-data-visualization"
}

resource "aws_glue_catalog_table" "sanitech_data_visualization" {
  name          = "sanitech-data-visualization"
  database_name = aws_glue_catalog_database.sanitech_data_visualization.name

  table_type = "EXTER
  }

  tags = {
    Name = "sanitech-data-visualization"
  }
}

resource "aws_kNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
inesis_stream" "sanitech_data_visualization" {
  name = "san  }

  storage_descriptoritech-data-visualization"

  shard_count = 1

  tags = {
    Name = "sanitech-data-visualization"
  }
}

resource "aws_lambda_function" "sanitech_data_visualization" {
  function_name = "sanitech-data-visualization"

  runtime = "python3.8"

  handler = "lambda_function.lambda_handler"

  role = aws_iam_role.sanitech_data_visualization.arn

  filename = "lambda_function.zip"

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.sanitech_data_visualization.name
    }
  }

  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_iam_role" "sanitech_data_visualization" {
  name = "sanitech-data-visualization"

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

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonKinesisFullAccess",
  ]

  inline_policy {
    name = "sanitech-data-visualization-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "kinesis:PutRecord"
          Resource = aws_kinesis_stream.sanitech_data_visualization.arn
        }
      ]
    })
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "sanitech_data_visualization" {
  name = "/aws/lambda/sanitech-data-visualization"

  retention_in_days = 30
}

resource "aws_cloudwatch_event_rule" "sanitech_data_visualization" {
  name_prefix = "sanitech-data-visualization-"

  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "sanitech_data_visualization" {
  rule = aws_cloudwatch_event_rule.sanitech_data_visualization.name
  arn  = aws_lambda_function.sanitech_data_visualization.arn
}

resource "aws_lambda_permission" "sanitech_data_visualization" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sanitech_data_visualization.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sanitech_data_visualization.arn
}

resource "aws_iam_role_policy_attachment" "sanitech_data_visualization" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.sanitech_data_visualization.name
}

resource "aws_iam_role_policy_attachment" "sanitech_data_visualization_elasticsearch" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticsearchServiceFullAccess"
  role       = aws_iam_role.sanitech_data_visualization.name
}

resource "aws_iam_role_policy_attachment" "sanitech_data_visualization_cloudwatch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.sanitech_data_visualization.name
}
