provider "aws" {
  version = "~> 3.11"
  region  = var.region
}

provider "aws" {
  version = "~> 3.11"
  alias   = "us-east-1"
  region  = "us-east-1"
}

terraform {
  required_version = "= 0.13.4"
}

terraform {
  backend "s3" {
    bucket = "covid-shield-demo-tf-storage"
    key    = "aws/backend/default.tfstate"
    region = "ca-central-1"
  }
}
