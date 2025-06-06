provider "aws" {
  region = var.aws_region
}

module "networking" {
  source               = "./modules/networking"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source         = "./modules/security"
  vpc_id         = module.networking.vpc_id
  project_name   = var.project_name
  environment    = var.environment
  vpc_cidr_block = var.vpc_cidr_block
  allowed_cidr   = var.allowed_cidr
}

module "compute" {
  source = "./modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  public_subnets        = module.networking.public_subnet_ids
  private_subnets       = module.networking.private_subnet_ids
  app_security_group_id = module.security.app_security_group_id
  alb_security_group_id = module.security.alb_security_group_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  max_size              = var.asg_max_size
  min_size              = var.asg_min_size
  desired_capacity      = var.asg_desired_capacity
}
