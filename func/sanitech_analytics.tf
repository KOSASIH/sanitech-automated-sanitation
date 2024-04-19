provider "aws" {
  region = "us-east-1"
}

resource "aws_kinesis_stream" "sanitech_telemetry" {
  name             = "sanitech-telemetry"
  shard_count      = 1
  retention_period = 24
}

resource "aws_kinesis_firehose_delivery_stream" "sanitech_analytics" {
  name        = "sanitech-analytics"
  destination = "elasticsearch"

  elasticsearch {
    domain_arn = aws_elasticsearch_domain.sanitech_analytics.arn
    index_name = "telemetry"
    type_name  = "_doc"
  }
}

resource "aws_elasticsearch_domain" "sanitech_analytics" {
  domain_name           = "sanitech-analytics"
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
        Resource = "${aws_elasticsearch_domain.sanitech_analytics.arn}/*"
      }
    ]
  })
}

resource "aws_elasticsearch_index" "telemetry" {
  domain_name = aws_elasticsearch_domain.sanitech_analytics.domain_name
  index_name  = "telemetry"

  dynamic "analysis" {
    for_each = var.analysis_config

    content {
      analyzer {
        name = analysis.value["name"]

        char_filter {
          type = analysis.value["char_filter"]
        }

        tokenizer {
          type = analysis.value["tokenizer"]
        }
      }
    }
  }

  dynamic "mapping" {
    for_each = var.mapping_config

    content {
      properties {
        name = mapping.value["name"]

        dynamic "type" {
          for_each = mapping.value["fields"]

          content {
            type = type.value["type"]
          }
        }
      }
    }
  }
}

variable "analysis_config" {
  type = map(object({
    name = string
    char_filter = string
    tokenizer = string
  }))

  default = {
    "standard" = {
      name = "standard"
      char_filter = "html_strip"
      tokenizer = "standard"
    }
  }
}

variable "mapping_config" {
  type = map(object({
    name = string
    fields = list(object({
      name = string
      type = string
    }))
  }))

  default = {
    "telemetry" = {
      name = "telemetry"
      fields = [
        {
          name = "timestamp"
          type = "date"
        },
        {
          name = "device_id"
          type = "keyword"
        },
        {
          name = "temperature"
          type = "half_float"
        },
        {
          name = "humidity"
          type = "half_float"
        },
        {
          name = "pressure"
          type = "half_float"
        }]
    }
  }
}
