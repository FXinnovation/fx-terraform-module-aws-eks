#####
# Datasources
#####

data "aws_subnet" "this" {
  id = var.subnet_ids[0]
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "allow_ec2_describe" {
  statement {
    sid = "1"

    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeInternetGateways"
    ]

    resources = ["*"]
  }
}
