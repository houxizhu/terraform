provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.this_name}"

  versioning {
    enabled = false
  }

  lifecycle {
    prevent_destroy = true
  }
}