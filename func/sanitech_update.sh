#!/bin/bash

echo "Updating Terraform state..."
terraform state pull > terraform.tfstate

echo "Refreshing Terraform state..."
terraform refresh

echo "Pushing updated Terraform state to backend..."
terraform state push -force
