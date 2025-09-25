variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "me-central-1"
}

variable "instance_type" {
  description = "Instance type for monitoring server"
  type        = string
  default     = "t3.large"
}

variable "app_instance_type" {
  description = "Instance type for app servers"
  type        = string
  default     = "t3.large"
}

variable "app_instance_count" {
  description = "Number of application instances"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "monitoring-purpose" # apna AWS key pair yaha rakho
}

variable "vpc_id" {
  description = "VPC ID (leave blank to use default)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Subnet IDs (leave blank to use default)"
  type        = list(string)
  default     = []
}

