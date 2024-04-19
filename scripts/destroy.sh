#!/bin/bash

echo "Destroying SaniTech infrastructure..."

# Navigate to the infrastructure directory
cd infrastructure

# Destroy the Terraform configuration
terraform init
terraform destroy -auto-approve

# Navigate back to the project root directory
cd ..

echo "SaniTech infrastructure destroyed successfully!"
