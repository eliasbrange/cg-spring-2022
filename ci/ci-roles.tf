resource "aws_iam_role" "auth-pr" {
  name = "eliasb-auth-pr"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity"
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.github.arn
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:sub" : "repo:eliasbrange/cg-spring-2022:pull_request"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "auth-pr-buckets" {
  role       = aws_iam_role.auth-pr.name
  policy_arn = aws_iam_policy.state-buckets.arn
}

resource "aws_iam_policy" "state-buckets" {
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
