output "s3" {
  description = "Databricks S3 metastore"

  value = {
    bucket = try(aws_s3_bucket.metastore[0].id, null)
    arn    = try(aws_s3_bucket.metastore[0].arn, null)
  }
}