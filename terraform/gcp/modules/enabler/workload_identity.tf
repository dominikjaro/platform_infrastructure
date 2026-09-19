# GCP Workload Identity Pool for the organization to federate the SA with GitHub
resource "google_iam_workload_identity_pool" "org_workload_identity_pool" {
  workload_identity_pool_id = "org-enabler-workload-id-pool"
  project                   = var.enabler_project_id
  display_name              = "org-workload-id-pool"
  description               = "Workload Identity Pool for the organization"
}
