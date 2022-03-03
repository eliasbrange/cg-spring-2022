resource "aws_s3_bucket" "ci_bucket" {
  bucket = "elias-brange-ci-cd"
}

resource "aws_s3_bucket_versioning" "ci_bucket_versioning" {
    bucket = aws_s3_bucket.ci_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}
