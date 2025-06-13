output "vpc" {
  description = "Databricks customer-managed VPCs"

  value = {
    for key, vpc in module.vpc : key => {
      vpc_id                  = vpc.vpc_id
      vpc_cidr_block          = vpc.vpc_cidr_block
      public_route_table_ids  = vpc.public_route_table_ids
      public_network_acl_id   = vpc.public_network_acl_id
      private_route_table_ids = vpc.private_route_table_ids
      private_network_acl_id  = vpc.private_network_acl_id
    }
  }
}

output "s3" {
  description = "Databricks S3 storage"

  value = {
    for key, s3 in aws_s3_bucket.root_storage : key => {
      bucket = s3.id
      arn    = s3.arn
    }
  }
}