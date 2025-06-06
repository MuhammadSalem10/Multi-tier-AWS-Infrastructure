output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.this.bucket
}
