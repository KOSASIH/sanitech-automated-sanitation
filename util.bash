#!/bin/bash

# Apply Kubernetes manifests
kubectl apply -f k8s/

# Apply Terraform configurations
terraform init
terraform apply -auto-approve
