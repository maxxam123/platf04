provider "PROVIDER" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket         = "dunhuang-gansu-terraform-state"
    key            = "dunhuang/terraform/s3/aws04/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform_state"
  }
}