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
  region = "ca-central-1"
}


resource "aws_instance" "example" {
  ami           = "ami-0eacb8127f9b58e90" # Ubuntu Server 26.04 LTS
  instance_type = "t3.medium"
  key_name      = "keytest"

  tags = {
    Env = "Prod"
  }
}
