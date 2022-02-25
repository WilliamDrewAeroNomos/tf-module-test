#---------------------------
# Development VPC
#---------------------------

module "ahroc_main_vpc" {

  source = "git::https://github.com/WilliamDrewAeroNomos/tf-modules.git//modules/vpc?ref=v1.1"
  # source = "../../tf-modules/modules/vpc"

  # insert required variables here

  _cidr_block = var.CIDR_BLOCK
  _name       = var.VPC_NAME

}
