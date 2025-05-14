locals {
  tags = {
    Name        = var.this_name
    deployment  = "terraform"
    created_by  = var.created_by
    link        = var.link
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "${var.this_name}"
  assume_role_policy = "${file("policies/${var.this_name}.json")}"

  # assume_role_policy = jsonencode({
  #   Version = "2012-10-17",
  #   Statement = [
  #     {
  #       Effect = "Allow",
  #       Principal = {
  #         Service = "ec2.amazonaws.com"
  #       },
  #       Action = "sts:AssumeRole"
  #     }
  #   ]
  # })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "eks_node_instance_profile" {
  name = "eks-node-instance-profile"
  role = aws_iam_role.eks_node_role.name
}
