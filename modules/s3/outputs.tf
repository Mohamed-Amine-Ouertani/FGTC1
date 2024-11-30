output "bucket_name" {
  value = aws_s3_bucket.training_data.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.training_data.arn
}
