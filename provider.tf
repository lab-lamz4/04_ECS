
terraform {
  required_version = "~> 0.13"
  backend "s3" {
    bucket = "learninig-state-lamz4-0"
    key    = "state/04_ecs.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = pathexpand("~/.aws/credentials")
}
