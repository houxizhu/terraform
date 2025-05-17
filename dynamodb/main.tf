provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

resource "aws_dynamodb_table" "this" {
  name           = "${var.this_name}"
  #billing_mode  = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
