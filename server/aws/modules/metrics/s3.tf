resource "random_string" "bucket_random_id" {
  length  = 5
  upper   = false
  number  = false
  special = false
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "masked_metrics" {

  # Versioning on this resource is handled through git
  # Logging is not required in the Demo environment
  # tfsec:ignore:AWS077 tfsec:ignore:AWS002

  bucket = "masked-metrics-${random_string.bucket_random_id.result}-${var.environment}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "unmasked_metrics" {

  # Versioning on this resource is handled through git
  # Logging is not required in the Demo environment
  # tfsec:ignore:AWS077 tfsec:ignore:AWS002

  bucket = "unmasked-metrics-${random_string.bucket_random_id.result}-${var.environment}"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}