

module "network" {
  source = "./modules/network"

  project_name = var.project_name
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availaibility_zone = "us-east-1a"

}

module "compute" {
  source = "./modules/compute"

  instance_type = "t3.micro"
  instance_number = var.instance_count
  volume_type = "gp3"
  subnet_id = module.network.public_subnet_id
  project_name = var.project_name
  security_group_id = module.security.security_group_id
  instance_profile = module.security.iam_instance_profile
  vpc_id = module.network.vpc_id

}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id = module.network.vpc_id

}