terraform {
  backend "s3" {
    bucket  = "shahaf-s3"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}