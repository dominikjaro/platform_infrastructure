module "enabler" {
  source                      = "../../modules/enabler"
  enabler_project_id          = var.enabler_project_id
  cloudbuild_project_id       = var.cloudbuild_project_id
  dominikjaro_prod_project_id = var.dominikjaro_prod_project_id
  dominikjaro_dev_project_id  = var.dominikjaro_dev_project_id
  enabler_region              = var.enabler_region
  billing_account_id          = var.billing_account_id
}
