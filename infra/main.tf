terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.49.0"
    }
  }
}

provider "aws" {
  # Configuration options
}


resource "aws_instance" "example" {
  region        = "ca-central-1"
  ami           = "ami-06445ac85e0d277a9"
  instance_type = "t3.medium"

  tags = {
    Env = "Prod"
  }
}
