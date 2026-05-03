output "bucket_id" {
  description = "Name of the S3 bucket."
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket."
  value       = aws_s3_bucket.main.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name (e.g. for CloudFront origin)."
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional bucket domain name."
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}
