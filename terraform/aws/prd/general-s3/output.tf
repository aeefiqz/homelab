output "arn" {
    value = { for k, v in module.s3-bucket : k => v.s3_bucket_arn }
}

output "bucket_id" {
    value = { for k, v in module.s3-bucket : k => v.s3_bucket_id }
}

output "bucket_policy" {
    value = { for k, v in module.s3-bucket : k => v.s3_bucket_policy }
}

output "bucket_lifecycle_rule" {
    value = { for k, v in module.s3-bucket : k => v.s3_bucket_lifecycle_configuration_rules }
}


