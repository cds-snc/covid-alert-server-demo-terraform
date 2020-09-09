provider "aws" {
  version = "~> 2.0"
  region  = "ca-central-1"
  allowed_account_ids = ["445131834497"]
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = "covid-shield-demo-tf-storage"
  acl    = "private"
  #tfsec:ignore:AWS002
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    ("CostCentre") = "CovidShield"
  }
}


resource "aws_route53_zone" "covidshield" {
  name = "covid-alert-demo.cdssandbox.xyz"

  tags = {
    ("CostCentre") = "CovidShield"
  }
}