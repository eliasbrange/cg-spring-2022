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
