
terraform {
  backend "s3" {
    bucket         = "dod-usarmy-cmh-arhoc-terraform-state"
    key            = "dev/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dod-usarmy-cmh-arhoc-terraform-state-locks"
    encrypt        = true
  }
}
