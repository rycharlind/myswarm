locals {
  name = "my-swarm"
}

provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}