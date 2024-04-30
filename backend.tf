terraform {
  backend "s3" {
    bucket = "cf-terraform-state-bucket"
    key    = "terraform-states/state.tfstate"
    region = "us-east-1"
  }
}
