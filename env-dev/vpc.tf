#---------------------------
# Development VPC
#---------------------------

module "ahroc_main_vpc" {

  #VPC_CIDR_BLOCK = "11.11.11.0/24"
  #ENVIRONMENT    = "development"

  source = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  # insert required variables here


  name = "dev-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Name        = "${var.ENVIRONMENT}-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}
