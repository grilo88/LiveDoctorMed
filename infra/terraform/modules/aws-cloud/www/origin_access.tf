resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "Access Identity for S3 bucket ${aws_s3_bucket.website.bucket}"
}