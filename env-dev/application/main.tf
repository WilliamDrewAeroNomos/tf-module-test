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

resource "aws_key_pair" "iac-ci-key" {
  key_name   = "iac-ci-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_security_group" "ahroc-front-end-sg" {
  vpc_id      = data.terraform_remote_state.network.outputs.vpc-main-id
  name        = "ahroc-front-end-sg"
  description = "Security group for AHROC front-end instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.ahroc-front-end-elb-sg.id]
  }

  tags = {
    Name = "ahroc-front-end-elb-sg"
  }
}

resource "aws_security_group" "ahroc-front-end-elb-sg" {
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

  security_groups = [aws_security_group.ahroc-front-end-elb-sg.id]

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

resource "aws_launch_configuration" "ahroc-front-end-launch-configuration" {
  name_prefix     = "ahroc-front-end-launch-configuration"
  image_id        = data.aws_ami.nodejs-image.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.iac-ci-key.key_name
  security_groups = [aws_security_group.ahroc-front-end-sg.id]
}

resource "aws_autoscaling_group" "ahroc-front-end-autoscaling" {
  name = "ahroc-front-end-autoscaling"
  vpc_zone_identifier = [element(data.terraform_remote_state.network.outputs.public_subnet_ids, 0),
  element(data.terraform_remote_state.network.outputs.public_subnet_ids, 1)]
  launch_configuration      = aws_launch_configuration.ahroc-front-end-launch-configuration.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  load_balancers            = [aws_elb.ahroc-front-end-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "AHROC Front-END ELB"
    propagate_at_launch = true
  }
}