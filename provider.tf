provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project     = var.project_name
      environment = var.project_environment
      ManagedBy   = "terraform"
    }
  }
}