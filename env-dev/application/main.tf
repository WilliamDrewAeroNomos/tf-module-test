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

output "ahroc-nodejs-image-id" {
  value = data.aws_ami.nodejs-image.id
}

