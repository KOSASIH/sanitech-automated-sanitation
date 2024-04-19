resource "aws_sagemaker_endpoint_configuration" "example" {
  name = "example-endpoint-config"

  production_variants {
    variant_name = "AllTraffic"

    model_name    = aws_sagemaker_model.example.id
    initial_instance_count = 1
    instance_type = "ml.m4.xlarge"
    initial_variant_weight = 1
  }
}

resource "aws_sagemaker_model" "example" {
  name = "example-model"

  primary_container {
    image = aws_ecr_repository.example.repository_url

    model_data_url = aws_s3_bucket_object.model_data.id
  }
}

resource "aws_s3_bucket_object" "model_data" {
  bucket = aws_s3_bucket.example.id
  key    = "model.tar.gz"
  source = "model.tar.gz"
}

resource "aws_s3_bucket" "example" {
bucket = "example-bucket"
}

resource "aws_ecr_repository" "example" {
  name = "example-repository"
}
