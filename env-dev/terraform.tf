variable "AWS_REGION" {
  description = "Default region"
  type        = string
  default     = "us-east-1"
}

variable "TF_STATE_S3_BUCKET_NAME" {
  description = "S3 bucket containing terraform state"
  type        = string
  default     = "testing-modularity-terraform-state"
}

variable "TF_STATE_DYNAMODB_TABLE_NAME" {
  description = "Dynamo database table"
  type        = string
  default     = "testing-modularity-terraform-state-locks"
}

# Defined for each environment testing

variable "ENVIRONMENT" {
  description = "Working context (i.e. - dev, test, pre-prod)"
  type        = string
}

variable "CIDR_BLOCK" {
  description = "Working context (i.e. - dev, test, pre-prod)"
  type        = string
}
