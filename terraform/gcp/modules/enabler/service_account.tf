# #GCP service account to be used by the IAC automation tasks
resource "google_service_account" "iac_automation" {
  account_id   = "iac-automation"
  display_name = "IAC Automation Service Account"
  project      = var.enabler_project_id
  description  = "This is the service account to handle Infrastructure as Code automation tasks for Terraform, GitHub and local inpersonations."
}

#GCP service account to be used by the CLoudBuild for CI/CD
