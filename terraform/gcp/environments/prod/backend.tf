terraform {
  backend "gcs" {
    bucket  = "terraform-state-bucket-org"
    prefix  = "terraform/state/${var.env}"
    project = var.enabler_project_id
  }
}
