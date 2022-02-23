variable "AWS_REGION" {
  description = "Default region"
  type        = string
  default     = "us-east-1"
}

# Defined for each environment testing

variable "ENVIRONMENT" {
  description = "Working context (i.e. - dev, test, pre-prod)"
  type        = string
}

variable "VPC_CIDR_BLOCK" {
  description = "Working context (i.e. - dev, test, pre-prod)"
  type        = string
}
