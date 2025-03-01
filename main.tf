provider "aws" {
  region = "us-east-1"
  }
  
  resource "aws_s3_bucket" "example" {
  bucket = "my-1st-s3-bucketaham"

  tags = {
    Name        = "My bucket"
  }
}

terraform {
  backend "s3" {
    bucket = "my-1st-s3-bucketaham1"
    key = "./terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
} 
