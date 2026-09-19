# GCP storage bucket to store the Terraform state file
resource "google_storage_bucket" "terraform_state_bucket" {
  name                     = "terraform-state-bucket-org"
  location                 = var.enabler_region
  project                  = var.enabler_project_id
  public_access_prevention = "enforced"
}
