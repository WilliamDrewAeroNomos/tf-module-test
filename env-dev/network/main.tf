#---------------------------
# Development environment
#---------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  elk_domain = "${var.ENVIRONMENT}-elk-domain"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

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

#resource "aws_subnet" "main-public-4" {
#  vpc_id                  = module.ahroc_main_vpc.vpc-main-id
#  cidr_block              = cidrsubnet(module.ahroc_main_vpc.vpc-cidr-block, 8, 3)
#  map_public_ip_on_launch = "true"
#  availability_zone       = data.aws_availability_zones.available.names[3]
#
#  tags = {
#    Name = "${var.ENVIRONMENT}-public-subnet-${data.aws_availability_zones.available.names[3]}"
#  }
#}

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

# Route table associations

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.main-public-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.main-public-3.id
  route_table_id = aws_route_table.public.id
}

# NAT'd subnets

resource "aws_subnet" "nated_1" {
  vpc_id            = module.ahroc_main_vpc.vpc-main-id
  cidr_block        = cidrsubnet(module.ahroc_main_vpc.vpc-cidr-block, 8, 4)
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.ENVIRONMENT}-nated-subnet-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_subnet" "nated_2" {
  vpc_id            = module.ahroc_main_vpc.vpc-main-id
  cidr_block        = cidrsubnet(module.ahroc_main_vpc.vpc-cidr-block, 8, 5)
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.ENVIRONMENT}-nated-subnet-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_subnet" "nated_3" {
  vpc_id            = module.ahroc_main_vpc.vpc-main-id
  cidr_block        = cidrsubnet(module.ahroc_main_vpc.vpc-cidr-block, 8, 6)
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "${var.ENVIRONMENT}-nated-subnet-${data.aws_availability_zones.available.names[2]}"
  }
}

# EIPs

resource "aws_eip" "nat_gw_eip_1" {
  vpc = true
}

resource "aws_eip" "nat_gw_eip_2" {
  vpc = true
}

resource "aws_eip" "nat_gw_eip_3" {
  vpc = true
}

# NAT gateway

resource "aws_nat_gateway" "gw_1" {
  allocation_id = aws_eip.nat_gw_eip_1.id
  subnet_id     = aws_subnet.main-public-1.id
}

resource "aws_nat_gateway" "gw_2" {
  allocation_id = aws_eip.nat_gw_eip_2.id
  subnet_id     = aws_subnet.main-public-2.id
}

resource "aws_nat_gateway" "gw_3" {
  allocation_id = aws_eip.nat_gw_eip_3.id
  subnet_id     = aws_subnet.main-public-3.id
}

# NAT'd subnet route tables

resource "aws_route_table" "nated_1" {
  vpc_id = module.ahroc_main_vpc.vpc-main-id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_1.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-nated-rt-1"
  }
}

resource "aws_route_table" "nated_2" {
  vpc_id = module.ahroc_main_vpc.vpc-main-id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_2.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-nated-rt-2"
  }
}

resource "aws_route_table" "nated_3" {
  vpc_id = module.ahroc_main_vpc.vpc-main-id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw_3.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-nated-rt-3"
  }
}

# Associations for NAT'd subnets and route tables

resource "aws_route_table_association" "nated_1" {
  subnet_id      = aws_subnet.nated_1.id
  route_table_id = aws_route_table.nated_1.id
}

resource "aws_route_table_association" "nated_2" {
  subnet_id      = aws_subnet.nated_2.id
  route_table_id = aws_route_table.nated_2.id
}

resource "aws_route_table_association" "nated_3" {
  subnet_id      = aws_subnet.nated_3.id
  route_table_id = aws_route_table.nated_3.id
}

# Service linked role

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

# ES domain

resource "aws_elasticsearch_domain" "es" {
  domain_name           = local.elk_domain
  elasticsearch_version = "7.7"

  cluster_config {
    instance_count         = 3
    instance_type          = "r5.large.elasticsearch"
    zone_awareness_enabled = true

    zone_awareness_config {
      availability_zone_count = 3
    }
  }

  vpc_options {
    subnet_ids = [
      aws_subnet.nated_1.id,
      aws_subnet.nated_2.id,
      aws_subnet.nated_3.id
    ]

    security_group_ids = [
      aws_security_group.es.id
    ]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "es:*",
          "Principal": "*",
          "Effect": "Allow",
          "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.elk_domain}/*"
      }
  ]
}
  CONFIG

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = local.elk_domain
  }
}

# ES security group

resource "aws_security_group" "es" {
  name = "${var.ENVIRONMENT}-es-sg"
  description = "Allow inbound traffic to ElasticSearch from VPC CIDR"
  vpc_id = module.ahroc_main_vpc.vpc-main-id

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
          module.ahroc_main_vpc.vpc-cidr-block
      ]
  }
}

# Outputs

output "elk_endpoint" {
  value = aws_elasticsearch_domain.es.endpoint
}

output "elk_kibana_endpoint" {
  value = aws_elasticsearch_domain.es.kibana_endpoint
}