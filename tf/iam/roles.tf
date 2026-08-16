resource "aws_iam_role" "snowplow_collector" {
  name        = "${local.prefix}-snowplow-collector-ec2-role"
  description = "Allows the collector nodes to access required services"
  tags        = local.tags

  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": [ "ec2.amazonaws.com" ]},
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "snowplow_iglu" {
  name        = "${local.prefix}-snowplow-iglu-ec2-role"
  description = "Allows the Iglu Server nodes to access required services"
  tags        = local.tags

  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": [ "ec2.amazonaws.com" ]},
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "eks_cluster" {
  name = "${local.prefix}-eks-cluster-role"
  description = "Allows the EKS Cluster to access required services"
  tags        = local.tags
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "eks_node" {
  name = "${local.prefix}-eks-node-role"
  description = "Allows the EKS Node to access required services"
  tags        = local.tags
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "terraform_deployer" {
  name        = "${local.prefix}-terraform-deployer-role"
  description = "Assumed by GitHub Actions via OIDC to deploy Terraform and application changes"
  tags        = local.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Federated": "${aws_iam_openid_connect_provider.github_actions.arn}" },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": [
            "repo:patrickoconnor80/patrick-cloud-base-infra:ref:refs/heads/main",
            "repo:patrickoconnor80/patrick-cloud-website:ref:refs/heads/main",
            "repo:patrickoconnor80/patrick-cloud-stock-screener:ref:refs/heads/main"
          ]
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "terraform_deployer" {
  role       = aws_iam_role.terraform_deployer.name
  policy_arn = aws_iam_policy.terraform_deployer.arn
}

resource "aws_iam_role_policy_attachment" "terraform_deployer_apps" {
  role       = aws_iam_role.terraform_deployer.name
  policy_arn = aws_iam_policy.terraform_deployer_apps.arn
}