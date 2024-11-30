# VPC Module
module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = var.vpc_cidr_block
  name        = var.vpc_name
}

# Subnet Module
module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.vpc_cidr_block
  availability_zones = var.availability_zones
}

# NAT Gateway Module
module "nat_gw" {
  source             = "./modules/nat-gw"
  public_subnet_ids  = module.subnet.public_subnet_ids
  availability_zones = var.availability_zones
}

# The Router Module
module "router" {
  source = "./modules/router"
  availability_zones= var.availability_zones
  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
  nat_gateway_ids = module.nat_gw.nat_gateway_ids
  public_subnet_ids = module.subnet.public_subnet_ids
  private_subnet_ids = module.subnet.private_subnet_ids
}

# AWS SSM Module
module "aws_ssm" {
  source      = "./modules/aws-ssm"
  environment = var.environment
}

# IAM Role Module
module "iam" {
  source          = "./modules/iam"
  environment     = var.environment
}

# EC2 Compute Module
module "compute" {
  source          = "./modules/compute"
  instance_number = var.instance_number
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  private_subnet_ids= module.subnet.private_subnet_ids
  iam_instance_profile = module.iam.iam_instance_profile_name
  fsx_dns_name =  module.fsx.fsx_dns_name
  environment = var.environment
}

# S3 Module
module "s3" {
  source      = "./modules/s3"
  bucket_name = "ai-training-data-${var.environment}"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.subnet.private_subnet_ids
  private_subnet_cidrs = module.subnet.private_subnet_cidrs
  users_ip_addresses = var.storage_users_ip_addresses
  region = var.region
  environment = var.environment
}

module "fsx" {
  source             = "./modules/fsx"
  storage_capacity   = var.fsx_storage_capacity
  subnet_ids         = module.subnet.private_subnet_ids
  s3_bucket_name     = module.s3.bucket_name
  vpc_id = module.vpc.vpc_id
  private_subnet_cidrs = module.subnet.private_subnet_cidrs
  users_ip_addresses = var.storage_users_ip_addresses
  environment        = var.environment
}

