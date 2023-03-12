data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  name = var.vpc_name
  cidr          = var.cidr_block
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnet_cidr_blocks
  public_subnets       = var.public_subnet_cidr_blocks
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true
  private_subnet_tags = {
    "Tier" = "private"
  }
  public_subnet_tags = {
    "Tier" = "public"
  }
  

  tags = merge(
    {
      Environment = var.environment

    }
    
  )
}