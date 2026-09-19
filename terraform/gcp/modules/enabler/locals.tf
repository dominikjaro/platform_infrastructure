###################
# Local variables for the projects
###################
locals {
  projects = {
    enabler_project = {
      project_id      = var.enabler_project_id
      name            = "org-enabler"
      billing_account = var.billing_account_id
    }

    cloudbuild_project = {
      project_id = var.cloudbuild_project_id
      name       = "org-cloudbuild"
    }

    dominikjaro_prod_project = {
      project_id = var.dominikjaro_prod_project_id
      name       = "dominikjaro-prod"
    }

    dominikjaro_dev_project = {
      project_id = var.dominikjaro_dev_project_id
      name       = "dominikjaro-dev"
    }
  }
}
