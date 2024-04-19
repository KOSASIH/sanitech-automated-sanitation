resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
}

resource "null_resource" "configuration_management" {
  provisioner "local-exec" {
    command = "aws s3 sync . s3://${aws_s3_bucket.example.bucket}"
  }
}
