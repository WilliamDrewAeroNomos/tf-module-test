#---------------------------
# Staging VPC
#---------------------------

module "ahroc_main_vpc" {

  source = "../modules/vpc"

  VPC_CIDR_BLOCK = "11.11.0.0/16"
  ENVIRONMENT = "staging"

}
