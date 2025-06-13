output "s3_catalog" {
  description = "Databricks S3 catalog"

  value = {
    for key, item in module.catalog : key => {
      bucket = item.bucket_name
      arn    = item.bucket_arn
    }
  }
}

output "s3_external_location" {
  description = "Databricks S3 external location"

  value = {
    for key, item in module.external_location : key => {
      bucket = item.bucket_name
      arn    = item.bucket_arn
    }
  }
}