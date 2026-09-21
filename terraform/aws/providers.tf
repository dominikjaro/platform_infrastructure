terraform {
  # backend "s3" {
  #   bucket = "infra-bucket-03"
  #   key    = "infra/terraform.tfstate"
  #   region = "eu-west-2"
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key

  default_tags {
    tags = {
      environment = var.env_prefix
      terraform   = "true"
    }
  }
}
