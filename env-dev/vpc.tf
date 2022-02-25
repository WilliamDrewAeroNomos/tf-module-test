#---------------------------
# Development VPC
#---------------------------

module "ahroc_main_vpc" {

//  source = "git::https://github.com/WilliamDrewAeroNomos/tf-modules.git//modules/vpc?ref=v1.0"
  source = "../../tf-modules/modules/vpc"

  # insert required variables here

  _cidr_block 	= var.CIDR_BLOCK
  _environment  = var.ENVIRONMENT

  #name = "dev-vpc"
  #cidr = "10.0.0.0/16"

  #azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  #enable_nat_gateway = true
  #enable_vpn_gateway = true

  #tags = {
  #Name        = "${var.ENVIRONMENT}-vpc"
  #Terraform   = "true"
  # Environment = "dev"
  #}
}
