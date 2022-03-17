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

resource "aws_elb" "ahroc-front-end-elb" {
  name = "ahroc-front-end-elb"

  subnets = [element(data.terraform_remote_state.network.outputs.public_subnet_ids, 0),
  element(data.terraform_remote_state.network.outputs.public_subnet_ids, 1)]

  security_groups = [aws_security_group.ahroc-front-end-elb-securitygroup.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/login"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "ahroc_front_end_sg_elb"
  }
}