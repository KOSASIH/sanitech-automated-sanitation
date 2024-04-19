provider "aws" {
  region = "us-east-1"
}

data "aws_sagemaker_notebook_instance" "example" {
  name = "example-notebook-instance"
}

resource "aws_sagemaker_endpoint_configuration" "example" {
  name = "example-endpoint-configuration"

  production_variants {
    variant_name = "example-variant"

    model_name    = aws_sagemaker_model.example.name
    initial_variant_weight = 1

    instance_type  = "ml.m5.large"
    initial_instance_count = 1

    variant_properties = {
      "AutoMLConfig" = jsonencode({
        "AutoMLType" = "REGRESSOR"
        "ObjectiveConfig" = {
          "MetricName" = "r2"
          "Type" = "Regression"
        }
        "DataConfig" = {
          "S3DataSource" = {
            "S3DataType" = "S3Prefix"
            "S3Uri" = "s3://example-bucket/data"
            "S3TargetKey" = "train"
          }
          "DataSchema" = {
            "ColumnSchemas" = [
              {
                "Name" = "feature1"
                "Type" = "String"
              },
              {
                "Name" = "feature2"
                "Type" = "String"
              },
              {
                "Name" = "target"
                "Type" = "Double"
              }
            ]
          }
        }
        "ResourceConfig" = {
          "InstanceType" = "ml.m5.large"
          "InstanceCount" = 1
          "VolumeSizeInGB" = 5
        }
      })
    }
  }
}

resource "aws_sagemaker_model" "example" {
  name = "example-model"

  primary_container {
    image = "example-image:latest"

    model_data_url = "s3://example-bucket/model.tar.gz"

    environment = {
      "KEY" = "VALUE"
    }

    mode = "SingleModel"
  }
}

resource "aws_sagemaker_endpoint" "example" {
  name = "example-endpoint"

  endpoint_config_name = aws_sagemaker_endpoint_configuration.example.name
}

output "endpoint_url" {
  value = aws_sagemaker_endpoint.example.endpoint_url
}
