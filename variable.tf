variable "aws_region" {
  description = "Region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "project_name" {
  description = "Name prefix for tagging"
  type        = string
  default     = "secure-aws-baseline"
}

variable "project_environment" {
  description = "environment prefix for tagging"
  type        = string
  default     = "dev"
}