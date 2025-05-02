provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

resource "tls_private_key" "ed25519" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "t_abeginner" {
  key_name   = "t_abeginner_ed25519"
  public_key = tls_private_key.ed25519.public_key_openssh
}
