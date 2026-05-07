terraform {
  backend "s3" {
    bucket = "utkarshmishra-terraform-backend-bucket"
    key    = "s3-backend"
    region = "us-east-1"
  }
}