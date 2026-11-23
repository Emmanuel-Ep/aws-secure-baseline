variable "aws_region" {
  description = "region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "name prefix of the project"
  type        = string
  default     = "secure-aws-infrastructure"
}

variable "project_environment" {
  description = "environment prefix for tagging"
  type        = string
  default     = "dev"
}

variable "instance_count" {
    description = "number of instances"
    type = map(string)
    default = {
        web1 = "t2.micro"
        web2 = "t3.micro"
    }
}