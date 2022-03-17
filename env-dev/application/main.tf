#
#
#

data "aws_ami" "nodejs-image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "tag:component-name"
    values = ["ahroc-nodejs-image"]
  }
}

resource "aws_security_group" "ahroc-front-end-elb-securitygroup" {
  vpc_id      = data.terraform_remote_state.network.outputs.vpc-main-id
  name        = "ahroc-front-end-elb-sg"
  description = "Security group for the AHROC front end nodes"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ahroc-front-end-elb-sg"
  }
}