resource "aws_iam_role" "role" {
  name = var.name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity"
        "Principal" : {
          "Federated" : var.oidc_provider_arn
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:sub" : var.subject_claim
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = var.state_buckets_policy_arn
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_policy" "policy" {
  name = "${var.name}-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : var.permissions,
        "Resource" : "*"
      }
    ]
  })
}
