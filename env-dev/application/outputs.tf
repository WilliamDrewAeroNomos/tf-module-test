
# Outputs


output "ahroc-nodejs-image-id" {
  value = data.aws_ami.nodejs-image.id
}

output "ahroc-front-end-elb-sg-id" {
  value = aws_security_group.ahroc-front-end-elb-securitygroup.id
}
