resource "aws_dynamodb_table" "dynamo_table" {
  name = "elias-brange-dynamodb"

  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2

  hash_key  = "PK"
  range_key = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }
}

resource "aws_ssm_parameter" "dynamo_table_name" {
  name  = "/eliasb/dynamodb_table_name"
  type  = "String"
  value = aws_dynamodb_table.dynamo_table.name
}

resource "aws_ssm_parameter" "test_ssm" {
  name  = "/eliasb/dynamo_test_ssm"
  type  = "String"
  value = aws_dynamodb_table.dynamo_table.name
}
