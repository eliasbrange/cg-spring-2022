module "auth-pr-role" {
  source = "./ci-role"

  name                     = "auth-read-role"
  subject_claim            = "repo:eliasbrange/cg-spring-2022:pull_request"
  oidc_provider_arn        = aws_iam_openid_connect_provider.github.arn
  state_buckets_policy_arn = aws_iam_policy.state_buckets_policy.arn
  permissions = [
    "route53:List*",
    "route53:Get*",
    "acm:Describe*",
    "acm:List*",
    "cognito-idp:Describe*",
    "cognito-idp:Get*",
    "ssm:Get*",
    "ssm:List*",
    "ssm:Describe*",
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
