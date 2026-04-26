locals {
  environment = "prd"
  region      = "ap-southeast-1"
  bucket_list = [
    "homelab-prd-terraform-state",
  ]
}


module "s3-bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "5.12.0"
  for_each      = toset(local.bucket_list)
  bucket        = each.key
  force_destroy = local.environment == "prd" ? false : true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  // ensure rollback  of previous state file
  versioning = {
    enabled = true
  }
  region = local.region
  // Block all public access to the bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"
  tags = merge(
    { "Environment" = "prd",
      "Project"     = "homelab",
      "Name"        = each.key
    },

  )
}