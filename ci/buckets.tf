resource "aws_s3_bucket" "ci_bucket" {
  bucket = "elias-brange-ci-cd"
}

resource "aws_s3_bucket_versioning" "ci_bucket_versioning" {
  bucket = aws_s3_bucket.ci_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "ci_bucket_useast" {
  provider = aws.useast
  bucket   = "elias-brange-ci-cd-us-east-1"
}

resource "aws_s3_bucket_versioning" "ci_bucket_versioning-useast" {
  provider = aws.useast
  bucket   = aws_s3_bucket.ci_bucket_useast.id
  versioning_configuration {
    status = "Enabled"
  }
}
