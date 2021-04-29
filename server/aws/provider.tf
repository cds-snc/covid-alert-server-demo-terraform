terraform {
  required_version = "= 0.14.2"
  backend "s3" {
    bucket = "covid-shield-demo-tf-storage"
    key    = "aws/backend/default.tfstate"
    region = "ca-central-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.37"
    }

  }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
