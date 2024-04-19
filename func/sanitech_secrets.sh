#!/bin/bash

echo "Initializing Terraform backend..."
terraform init -backend-config="bucket=example-bucket"

echo "Adding secrets to AWS Secrets Manager..."
aws secretsmanager create-secret --name example-secret --secret-string.example.branch]
    }
  }

  jobs = {
    "test" = {
      name   = "test"
      runs-on = "ubuntu-latest" '{"github_token": "your-github-token"}'

echo "Applying Terraform configuration..."
terraform apply -auto-approve
