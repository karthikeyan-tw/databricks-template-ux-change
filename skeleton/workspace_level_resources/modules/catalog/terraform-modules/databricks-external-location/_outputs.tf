output "id" {
  value = databricks_external_location.location.id
}

output "url" {
  value = databricks_external_location.location.url
}

output "bucket_name" {
  value = local.s3_bucket_id
}

output "bucket_arn" {
  value = local.s3_bucket_arn
}