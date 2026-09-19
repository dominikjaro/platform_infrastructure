variable "enabler_project_id" {
  description = "The project ID for the common services."
  type        = string
}

variable "cloudbuild_project_id" {
  description = "The project ID for the cloudbuild project."
  type        = string
}

variable "dominikjaro_prod_project_id" {
  description = "The project ID for the dominikjaro production project."
  type        = string
}

variable "dominikjaro_dev_project_id" {
  description = "The project ID for the dominikjaro development project."
  type        = string
}

variable "enabler_region" {
  type = string
}
variable "billing_account_id" {
  type        = string
  description = "The billing account ID to be used for the projects."
}

