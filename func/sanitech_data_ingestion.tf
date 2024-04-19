provider "aws" {
  region = "us-east-1"
}

resource "aws_kinesis_stream" "sanitech_data_ingestion" {
  name             = "sanitech-data-ingestion"
  shard_count      = 1
  retention_period = 24
}

resource "aws_kinesis_firehose_delivery_stream" "sanitech_data_ingestion" {
  name        = "sanitech-data-ingestion"
  destination = "elasticsearch"

  elasticsearch {
    domain_arn = aws_elasticsearch_domain.sanitech_elasticsearch.arn
    index_name = "sanitech-data-ingestion"
    type_name  = "_doc"
  }

  tags = {
    Environment = "production"
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
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = [
          "es:DescribeDomain",
          "es:DescribeElasticsearch",
          "es:ESHttpGet",
          "es:ESHttpHead",
          "es:ESHttpPost"
        ],
        Resource = "${aws_elasticsearch_domain.sanitech_elasticsearch.arn}/*"
      }
    ]
  })
}

resource "aws_lambda_function" "sanitech_data_ingestion" {
  filename      = "data_ingestion.zip"
  function_name = "sanitech-data-ingestion"
  role          = aws_iam_role.sanitech_lambda.arn
  handler       = "data_ingestion.handler"
  runtime       = "python3.8"

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.sanitech_data_ingestion.name
      FIREHOSE_DELIVERY_STREAM_NAME = aws_kinesis_firehose_delivery_stream.sanitech_data_ingestion.name
    }
  }

  vpc_config {
    subnet_ids = [aws_subnet.sanitech_private[0].id]
    security_group_ids = [aws_security_group.sanitech_lambda.id]
  }

  tags = {
    Environment = "production"
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
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sanitech_lambda.name
}

resource "aws_iam_role_policy_attachment" "sanitech_lambda_vpc_access" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.sanitech_lambda.name
}

resource "aws_subnet" "sanitech_private" {
  count = 2

  vpc_id     = aws_vpc.sanitech.id
  cidr_block = "10.0.${2 * count + 1}.0/24"

  tags = {
    Name = "sanitech-private-${count + 1}"
  }
}

resource "aws_security_group" "sanitech_lambda" {
  name_prefix = "sanitech-lambda-"

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
