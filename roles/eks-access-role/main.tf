locals {
  tags = {
    Name        = var.this_name
    deployment  = "terraform"
    created_by  = var.created_by
    link        = var.link
  }
}

resource "aws_iam_role" "eks_access_role" {
  name = "${var.this_name}"
  assume_role_policy = "${file("policies/${var.this_name}.json")}"

  # assume_role_policy = jsonencode({
  #   Version = "2012-10-17",
  #   Statement = [
  #     {
  #       Effect = "Allow",
  #       Principal = {
  #         AWS = "arn:aws:iam::471112672291:user/abeginner"
  #       },
  #       Action = "sts:AssumeRole"
  #     }
  #   ]
  # })

  tags = local.tags
}

data "aws_iam_policy" "access_eks" {
  name = "access-eks"
}

resource "aws_iam_role_policy_attachment" "eks_access_policy" {
  role       = aws_iam_role.eks_access_role.name
  policy_arn = data.aws_iam_policy.access_eks.arn
}
