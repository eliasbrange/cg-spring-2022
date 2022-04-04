resource "aws_cognito_user_pool" "pool" {
  name = "eliasb-cognito-pool"

  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_route53_record" "cognito_record" {
  name    = aws_cognito_user_pool_domain.pool_domain.domain
  type    = "A"
  zone_id = data.aws_route53_zone.zone.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.pool_domain.cloudfront_distribution_arn
    # Fixed Zone ID for CloudFront distributions
    zone_id = "Z2FDTNDATAQYW2"
  }
}

resource "aws_cognito_user_pool_domain" "pool_domain" {
  domain          = "${var.subdomain}.${var.domain}"
  certificate_arn = aws_acm_certificate.cert.arn
  user_pool_id    = aws_cognito_user_pool.pool.id
}

resource "aws_ssm_parameter" "pool_ssm" {
  name  = "/eliasb/cognito_user_pool"
  type  = "String"
  value = aws_cognito_user_pool.pool.id
}

resource "aws_ssm_parameter" "pool_ssm2" {
  name  = "/eliasb/cognito_user_pool2"
  type  = "String"
  value = aws_cognito_user_pool.pool.id
}
