provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "sanitech_data_storage" {
  bucket = "sanitech-data-storage"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_policy" "sanitech_data_storage_policy" {
  bucket = aws_s3_bucket.sanitech_data_storage.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Principal = {
          AWS = "*"
        }
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.sanitech_data_storage.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = aws_vpc.sanitech.id
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "sanitech_data_storage_block" {
  bucket                  = aws_s3_bucket.sanitech_data_storage.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
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

resource "aws_security_group" "sanitech_data_storage" {
  name_prefix = "sanitech-data-storage-"

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
