
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.TF_STATE_DYNAMODB_TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

