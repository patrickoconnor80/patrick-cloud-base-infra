resource "aws_iam_policy" "terraform_deployer" {
  name        = "${local.prefix}-terraform-deployer-policy"
  description = "Terraform Deployer policy to creat and destroy reousrces in AWS"
  policy      = data.aws_iam_policy_document.terraform_deployer.json
}

data "aws_iam_policy_document" "terraform_deployer" {

  statement {
    sid    = "Describe"
    effect = "Allow"
    actions   = [
        "ec2:Describe*",
        "elasticloadbalancing:Describe*",
        "route53:ListHostedZones",
        "route53:GetHostedZone",
        "autoscaling:Describe*",
        "ecr-public:GetAuthorizationToken",
        "sts:GetServiceBearerToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EC2"
    effect = "Allow"
    actions = [
        "ec2:Describe*"
    ]
    resources = ["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*"]
  }

  statement {
    sid    = "ElasticLoadBalancing"
    effect = "Allow"
    actions = [
        "elasticloadbalancing:List*",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:RemoveTags"
    ]
    resources = [
        "arn:aws:elasticloadbalancing:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:targetgroup/${local.prefix}-*",
        "arn:aws:elasticloadbalancing:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:loadbalancer/app/${local.prefix}-*"
    ]
  }

  statement {
    sid    = "Autoscaling"
    effect = "Allow"
    actions = [
        "autoscaling:AttachLoadBalancerTargetGroups",
        "autoscaling:DetachLoadBalancerTargetGroups"
    ]
    resources = ["arn:aws:autoscaling:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:autoScalingGroup/*"]
  }


  statement {
    sid    = "SNSListTopics"
    effect = "Allow"
    actions = ["sns:ListTopics"]
    resources = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    sid    = "SNS"
    effect = "Allow"
    actions = [
        "sns:Get*",
        "sns:CreateTopic",
        "sns:DeleteTopic",
        "sns:SetTopicAttributes"
    ]
    resources = ["arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.prefix}-*"]
  }

  statement {
    sid    = "WAFV2"
    effect = "Allow"
    actions = [
      "wafv2:Get*",
      "wafv2:List*",
      "wafv2:TagResource",
      "wafv2:UntagResource"
    ]
    resources = ["arn:aws:wafv2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:global/webacl/${local.prefix}-*"]
  }

  statement {
    sid    = "S3TFStateFile"
    effect = "Allow"
    actions = [
        "s3:GetObject",
        "s3:PutObject"
    ]
    resources = [
        "arn:aws:s3:::terraform-state-harry-prod",
        "arn:aws:s3:::terraform-state-harry-prod/*",
        "arn:aws:s3:::patrick-cloud-tf-state",
        "arn:aws:s3:::patrick-cloud-tf-state/*"
    ]
  }

  statement {
    sid    = "S3"
    effect = "Allow"
    actions = [
        "s3:Get*",
        "s3:List*",
        "s3:CreateBucket",
        "s3:DeleteBucket",
        "s3:DeleteBucketPolicy",
        "s3:DeleteBucketWebsite",
        "s3:PutBucketPolicy",
        "s3:PutBucketWebsite",
        "s3:PutBucketTagging",
        "s3:PutObject",
        "s3:PutAccelerateConfiguration"
    ]
    resources = [
      "arn:aws:s3:::${local.prefix}-*",
      "arn:aws:s3:::patrick-cloud.com*"
    ]
  }

  statement {
    sid    = "Cloudwatch"
    effect = "Allow"
    actions = [
        "cloudwatch:Describe*",
        "cloudwatch:List*",
        "cloudwatch:UnTag*",
        "cloudwatch:Tag*"
    ]
    resources = ["arn:aws:cloudwatch:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alarm:${local.prefix}-*"]
  }

  statement {
    sid    = "Route53"
    effect = "Allow"
    actions = [
        "route53:List*"
    ]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  
  statement {
    sid    = "Cloudfront"
    effect = "Allow"
    actions = [
        "cloudfront:Get*",
        "cloudfront:List*",
        "cloudfront:TagResource",
        "cloudfront:UntagResource",

    ]
    resources = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"]
  }

  statement {
    sid    = "SecurityGroups"
    effect = "Allow"
    actions = [
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:ModifySecurityGroupRules",
        "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
        "ec2:UpdateSecurityGroupRuleDescriptionsEgress"
    ]
    resources = ["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:security-group/*"]
  }

  statement {
    sid    = "VPC"
    effect = "Allow"
    actions = [
        "ec2:CreateSecurityGroup"
    ]
    resources = ["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vpc/vpc-*"]
  }

  statement {
    sid    = "SecretsManager"
    effect = "Allow"
    actions = [
        "secretsmanager:Describe*",
        "secretsmanager:List*",
        "secretsmanager:Get*"
    ]
    resources = ["arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*"]
  }

  statement {
    sid    = "IAMPolicy"
    effect = "Allow"
    actions = [
        "iam:ListPolicies",
        "iam:GetPolicy",
        "iam:GetPolicyVersion"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/*"]
  }

  statement {
    sid    = "CreateIAMPolicy"
    effect = "Allow"
    actions = [
        "iam:CreatePolicy"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.prefix}-*"]
  }

  statement {
    sid    = "IAMRole"
    effect = "Allow"
    actions = [
        "iam:GetRole",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:ListInstanceProfilesForRole"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
  }

  statement {
    sid    = "OpenIDIAMRole"
    effect = "Allow"
    actions = [
        "iam:GetOpenIDConnectProvider",
        "iam:CreateOpenIDConnectProvider",
        "iam:DeleteOpenIDConnectProvider"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/*"]
  }

  statement {
    sid    = "CreateIAMRole"
    effect = "Allow"
    actions = [
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PassRole",
        "iam:TagRole"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.prefix}-*"]
  }

  statement {
    sid    = "EKSCluster"
    effect = "Allow"
    actions = [
        "eks:List*",
        "eks:Describe*",
        "eks:Tag*",
        "eks:Untag*",
        "eks:CreateCluster",
        "eks:DeleteCluster",
        "eks:CreateNodegroup",
        "eks:DeleteNodegroup",
        "eks:CreateAccessEntry",
        "eks:UpdateClusterConfig",
        "eks:AssociateIdentityProviderConfig",
        "eks:CreateAddon",
        "eks:DeleteAddon",
        "eks:UpdateAddon",
        "eks:DescribeAddon"
    ]
    resources = ["arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${local.prefix}-*"]
  }

  statement {
    sid    = "EKSClusterAddon"
    effect = "Allow"
    actions = [
        "eks:DescribeAddon",
        "eks:DeleteAddon"
    ]
    resources = ["arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    sid    = "EKSNodegroup"
    effect = "Allow"
    actions = [
        "eks:List*",
        "eks:Describe*",
        "eks:CreateNodegroup",
        "eks:DeleteNodegroup",
        "eks:Tag*",
        "eks:Untag*"
    ]
    resources = ["arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:nodegroup/${local.prefix}-*/${local.prefix}-*"]
  }

  statement {
    sid    = "AssociateAccessPolicyEKSCluster"
    effect = "Allow"
    actions = [
        "eks:Describe*",
        "eks:List*",
        "eks:AssociateAccessPolicy",
        "eks:DisassociateAccessPolicy",
        "eks:DeleteAccessEntry"
    ]
    resources = ["arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:access-entry/${local.prefix}-*"]
  }

  statement {
    sid    = "SSM"
    effect = "Allow"
    actions = [
        "ssm:Get*",
        "ssm:PutParameter"
    ]
    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }

  statement {
    sid    = "CloudwatchLogs"
    effect = "Allow"
    actions = [
        "logs:Get*",
        "logs:Describe*",
        "logs:List*"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group::log-stream:*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/*"
    ]
  }

  statement {
    sid    = "CloudwatchEvents"
    effect = "Allow"
    actions = [
        "events:Get*",
        "events:Describe*",
        "events:List*"
    ]
    resources = ["arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rule/*"]
  }

  statement {
    sid    = "SQS"
    effect = "Allow"
    actions = [
        "sqs:Get*",
        "sqs:Describe*",
        "sqs:List*"
    ]
    resources = ["arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }

}