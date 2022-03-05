resource "aws_route53_zone" "zone" {
  name = "aws.eliasbrange.dev"
}

resource "aws_ssm_parameter" "dynamo_table_name" {
  name = "/eliasb/hosted_zone_id"
  type = "String"
  value = "${aws_route53_zone.zone.zone_id}"
}
