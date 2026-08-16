# Split from policy_terraform_deployer.tf: the original policy document is already
# within a few hundred bytes of AWS's 6144-byte managed-policy size limit, so new
# permissions for deploying Lambda-based apps (stock screener, etc.) go here instead
# and get attached to the same terraform_deployer role as a second managed policy.

resource "aws_iam_policy" "terraform_deployer_apps" {
  name        = "${local.prefix}-terraform-deployer-apps-policy"
  description = "Terraform Deployer policy for Lambda/EventBridge/ECR app deployments and CloudFront invalidation"
  policy      = data.aws_iam_policy_document.terraform_deployer_apps.json
}

data "aws_iam_policy_document" "terraform_deployer_apps" {

  statement {
    sid    = "Lambda"
    effect = "Allow"
    actions = [
        "lambda:CreateFunction",
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration",
        "lambda:GetPolicy",
        "lambda:UpdateFunctionCode",
        "lambda:UpdateFunctionConfiguration",
        "lambda:DeleteFunction",
        "lambda:AddPermission",
        "lambda:RemovePermission",
        "lambda:PublishVersion",
        "lambda:TagResource",
        "lambda:UntagResource",
        "lambda:ListVersionsByFunction",
        "lambda:InvokeFunction",
        "lambda:ListTags"
    ]
    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${local.prefix}-*"]
  }

  statement {
    sid    = "EventBridgeManage"
    effect = "Allow"
    actions = [
        "events:PutRule",
        "events:PutTargets",
        "events:RemoveTargets",
        "events:DeleteRule",
        "events:EnableRule",
        "events:DisableRule",
        "events:TagResource",
        "events:UntagResource",
        "events:ListTagsForResource"
    ]
    resources = ["arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rule/${local.prefix}-*"]
  }

  statement {
    sid    = "ECRAuth"
    effect = "Allow"
    actions = [
        "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ECRRepository"
    effect = "Allow"
    actions = [
        "ecr:CreateRepository",
        "ecr:DescribeRepositories",
        "ecr:SetRepositoryPolicy",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:TagResource",
        "ecr:ListTagsForResource"
    ]
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/${local.prefix}-*"]
  }

  statement {
    sid    = "IAMTagsRead"
    effect = "Allow"
    actions = [
        "iam:ListRoleTags",
        "iam:ListPolicyTags"
    ]
    resources = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.prefix}-*",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.prefix}-*"
    ]
  }

  statement {
    sid    = "IAMPolicyVersionManage"
    effect = "Allow"
    actions = [
        "iam:ListPolicyVersions",
        "iam:CreatePolicyVersion",
        "iam:DeletePolicyVersion"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.prefix}-*"]
  }

  statement {
    sid    = "CloudfrontInvalidation"
    effect = "Allow"
    actions = [
        "cloudfront:CreateInvalidation",
        "cloudfront:GetInvalidation"
    ]
    resources = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"]
  }

  statement {
    sid    = "GitHubOIDCProviderRead"
    effect = "Allow"
    actions = [
        "iam:GetOpenIDConnectProvider"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
  }

}
