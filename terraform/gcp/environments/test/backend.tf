terraform {
  backend "gcs" {
    bucket  = "terraform-state-bucket-dev"
    prefix  = "terraform/state/${var.env}"
    project = var.enabler_project_id
  }
}
