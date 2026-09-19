terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-org"
  }
}
