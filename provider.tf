provider "aws" {
  region = "us-east-1"


  default_tags {
    tags = {
      project     = var.project_name
      environment         = var.project_environment
      ManagedBy = "Terraform"
      Owner = "Emmanuel"
    }
  }
}


   
   