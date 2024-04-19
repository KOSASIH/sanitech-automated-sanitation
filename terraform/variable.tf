variable "resource_tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default = {
    project     = "sanitech"
    environment = "dev"
  }

  validation {
    condition     = length(var.resource_tags["project"]) <= 16 && length(var.resource_tags["environment"]) <= 8
    error_message = "The project and environment tags must be no more than 16 and 8 characters, respectively."
  }
}

variable "aws_region" {
  description = "The AWS region where all resources will be created."
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_count" {
  description = "Number of EC2 instances to create."
  type        = number
  default     = 1
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type."
  type        = string
}

variable "plans" {
  description = "A map of server plans and their corresponding details."
  type = map(object({
    cpu    = number
    memory = number
  }))
  default = {
    "5USD"  = { cpu = 1, memory = 1 }
    "10USD" = { cpu = 1, memory = 2 }
    "20USD" = { cpu = 2, memory = 4 }
  }
}

variable "storage_sizes" {
  description = "A map of storage sizes for each server plan."
  type = map(number)
  default = {
    "1xCPU-1GB"  = 25
    "1xCPU-2GB"  = 50
    "2xCPU-4GB"  = 80
  }
}

variable "set_password" {
  description = "Whether to generate a root user password on a new deployment."
  type        = bool
  default     = true
}

variable "password_length" {
  description = "The length of the generated password."
  type        = number
  default     = 16

  validation {
    condition     = var.password_length >= 8 && var.password_length <= 64
    error_message = "The password length must be between 8 and 64 characters."
  }
}

variable "password_characters" {
  description = "The allowed characters for the generated password."
  type        = string
  default     = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:,.<>?/~"

  validation {
    condition     = length(var.password_characters) >= 8 && length(var.password_characters) <= 64
    error_message = "The password characters must be between 8 and 64 characters."
  }
}
