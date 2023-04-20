terraform {
  required_version = "1.4.5"

  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.0"
      }
  }
}
provider "aws" {
  access_key = "AKIATUCAAUWJMMMFX5XO"
  secret_key = "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"
  region = "ap-northeast-3"
}