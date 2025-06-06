terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket-salem"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
