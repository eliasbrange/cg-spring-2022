resource "aws_route53_zone" "zone" {
  name = "aws.eliasbrange.dev"
}

resource "aws_ssm_parameter" "hosted_zone_id" {
  name  = "/eliasb/hosted_zone_id"
  type  = "String"
  value = aws_route53_zone.zone.zone_id
}

resource "aws_ssm_parameter" "hosted_zone_id2" {
  name  = "/eliasb/hosted_zone_id2"
  type  = "String"
  value = aws_route53_zone.zone.zone_id
}

resource "aws_ssm_parameter" "hosted_zone_id_useast" {
  provider = aws.useast
  name     = "/eliasb/hosted_zone_id"
  type     = "String"
  value    = aws_route53_zone.zone.zone_id
}

resource "aws_route53_record" "root_record" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "aws.eliasbrange.dev"
  type    = "A"
  ttl     = 300
  records = ["127.0.0.1"]
}
