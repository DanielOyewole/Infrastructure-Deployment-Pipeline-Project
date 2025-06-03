terraform {
  backend "s3" {
    bucket = "my-terraform-state-infra"      # <-- your actual S3 bucket name
    key    = "state/terraform.tfstate"       # <-- your actual state file path/key
    region = "us-east-1"                     # <-- your S3 bucket's region
  }
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
