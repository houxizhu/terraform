locals {
  tags = {
    Name        = var.this_name
    deployment  = "terraform"
    created_by  = var.created_by
    link        = var.link
  }
}

data "template_file" "this" {
  template = "${file("policies/${var.this_name}.json")}"

  vars = {
    this_name      = var.this_name
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.this_name}"
  description = "policy-${var.this_name}"
  policy      = data.template_file.this.rendered

  tags = local.tags
}
