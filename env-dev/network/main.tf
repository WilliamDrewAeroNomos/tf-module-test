#---------------------------
# Development environment
#---------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

module "ahroc_main_vpc" {

  #source = "git::https://github.com/WilliamDrewAeroNomos/tf-modules.git//modules/vpc?ref=v2.0.0"
  source = "../../../tf-modules/modules/vpc"

  # insert required variables here

  _cidr_block = var.CIDR_BLOCK
  _name       = var.VPC_NAME

}

# Subnets

resource "aws_subnet" "main-public-1" {
  vpc_id                  = module.ahroc_main_vpc.vpc-main-id
  cidr_block              = cidrsubnet(module.ahroc_main_vpc.vpc-cidr-block, 8, 0)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.ENVIRONMENT}-public-subnet-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_subnet" "main-public-2" {
  vpc_id                  = module.ahroc_main_vpc.vpc-main-id
  cidr_block              = cidrsubnet(module.ahroc_main_vpc.vpc-cidr-block, 8, 1)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.ENVIRONMENT}-public-subnet-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_subnet" "main-public-3" {
  vpc_id                  = module.ahroc_main_vpc.vpc-main-id
  cidr_block              = cidrsubnet(module.ahroc_main_vpc.vpc-cidr-block, 8, 2)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "${var.ENVIRONMENT}-public-subnet-${data.aws_availability_zones.available.names[2]}"
  }
}

resource "aws_subnet" "main-public-4" {
  vpc_id                  = module.ahroc_main_vpc.vpc-main-id
  cidr_block              = cidrsubnet(module.ahroc_main_vpc.vpc-cidr-block, 8, 3)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[3]

  tags = {
    Name = "${var.ENVIRONMENT}-public-subnet-${data.aws_availability_zones.available.names[3]}"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "igw-main" {
  vpc_id = module.ahroc_main_vpc.vpc-main-id

  tags = {
    Name = "${var.ENVIRONMENT}-igw"
  }
}

# Route table

resource "aws_route_table" "public" {
    vpc_id = module.ahroc_main_vpc.vpc-main-id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-main.id
    }

    tags = {
        Name = "${var.ENVIRONMENT}-public-rt"
    }
}


