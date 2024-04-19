#!/bin/bash

echo "Applying SaniTech infrastructure..."

# Navigate to the infrastructure directory
cd infrastructure

# Apply the Terraform configuration
terraform init
terraform apply -auto-approve

# Navigate back to the project root directory
cd ..

echo "SaniTech infrastructure applied successfully!"
