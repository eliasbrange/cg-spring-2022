module "auth_pr_role" {
  source = "./ci-role"

  name                     = "auth-read-role"
  subject_claim            = "repo:eliasbrange/cg-spring-2022:pull_request"
  oidc_provider_arn        = aws_iam_openid_connect_provider.github.arn
  state_buckets_policy_arn = aws_iam_policy.state_buckets_policy.arn
  permissions = [
    "acm:Describe*",
    "acm:Get*",
    "acm:List*",
    "cognito-idp:Describe*",
    "cognito-idp:Get*",
    "cognito-idp:List*",
    "route53:Describe*",
    "route53:Get*",
    "route53:List*",
    "ssm:Describe*",
    "ssm:Get*",
    "ssm:List*",
  ]
}

module "auth_deploy_role" {
  source = "./ci-role"

  name                     = "auth-deploy-role"
  subject_claim            = "repo:eliasbrange/cg-spring-2022:ref:refs/heads/main"
  oidc_provider_arn        = aws_iam_openid_connect_provider.github.arn
  state_buckets_policy_arn = aws_iam_policy.state_buckets_policy.arn
  permissions = [
    "acm:DeleteCertificate",
    "acm:Describe*",
    "acm:Get*",
    "acm:List*",
    "acm:RequestCertificate",
    "cognito-idp:CreateUserPool",
    "cognito-idp:CreateUserPoolDomain",
    "cognito-idp:DeleteUserPool",
    "cognito-idp:DeleteUserPoolDomain",
    "cognito-idp:Describe*",
    "cognito-idp:Get*",
    "cognito-idp:List*",
    "cognito-idp:SetUserPoolMfaConfig",
    "cognito-idp:UpdateUserPool",
    "route53:ChangeResourceRecordSets",
    "route53:Describe*",
    "route53:Get*",
    "route53:List*",
    "ssm:Describe*",
    "ssm:Get*",
    "ssm:List*",
    "ssm:PutParameter",
    "ssm:DeleteParameter",
  ]
}

module "db_pr_role" {
  source = "./ci-role"

  name                     = "db-read-role"
  subject_claim            = "repo:eliasbrange/cg-spring-2022:pull_request"
  oidc_provider_arn        = aws_iam_openid_connect_provider.github.arn
  state_buckets_policy_arn = aws_iam_policy.state_buckets_policy.arn
  permissions = [
    "dynamodb:Describe*",
    "dynamodb:Get*",
    "dynamodb:List*",
    "ssm:Describe*",
    "ssm:Get*",
    "ssm:List*",
  ]
}

module "db_deploy_role" {
  source = "./ci-role"

  name                     = "db-deploy-role"
  subject_claim            = "repo:eliasbrange/cg-spring-2022:ref:refs/heads/main"
  oidc_provider_arn        = aws_iam_openid_connect_provider.github.arn
  state_buckets_policy_arn = aws_iam_policy.state_buckets_policy.arn
  permissions = [
    "dynamodb:*",
    "ssm:*",
  ]
}

module "dns_pr_role" {
  source = "./ci-role"

  name                     = "dns-read-role"
  subject_claim            = "repo:eliasbrange/cg-spring-2022:pull_request"
  oidc_provider_arn        = aws_iam_openid_connect_provider.github.arn
  state_buckets_policy_arn = aws_iam_policy.state_buckets_policy.arn
  permissions = [
    "route53:Describe*",
    "route53:Get*",
    "route53:List*",
    "ssm:Describe*",
    "ssm:Get*",
    "ssm:List*",
  ]
}

module "dns_deploy_role" {
  source = "./ci-role"

  name                     = "dns-deploy-role"
  subject_claim            = "repo:eliasbrange/cg-spring-2022:ref:refs/heads/main"
  oidc_provider_arn        = aws_iam_openid_connect_provider.github.arn
  state_buckets_policy_arn = aws_iam_policy.state_buckets_policy.arn
  permissions = [
    "route53:*",
    "ssm:*",
  ]
}

module "sam_deploy_role" {
  source = "./ci-role"

  name                     = "sam-deploy-role"
  subject_claim            = "repo:eliasbrange/cg-spring-2022:ref:refs/heads/main"
  oidc_provider_arn        = aws_iam_openid_connect_provider.github.arn
  state_buckets_policy_arn = aws_iam_policy.state_buckets_policy.arn
  permissions = [
    "lambda:*",
    "ssm:*",
  ]
}

resource "aws_iam_policy" "state_buckets_policy" {
  name        = "eliasb-access-state-buckets"
  description = "Access to state buckets"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          aws_s3_bucket.ci_bucket.arn,
          aws_s3_bucket.ci_bucket_useast.arn,
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.ci_bucket.arn}/*",
          "${aws_s3_bucket.ci_bucket_useast.arn}/*",
        ]
      }
    ]
  })
}
