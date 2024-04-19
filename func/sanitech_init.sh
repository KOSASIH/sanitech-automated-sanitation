#!/bin/bash

echo "Initializing Terraform backend..."
terraform init -backend-config="bucket=example-bucket"

echo "Applying Terraform configuration..."
terraform apply -auto-approve
