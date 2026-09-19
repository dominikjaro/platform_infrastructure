variable "enabler_region" {
  type = string
}

variable "enabler_project_id" {
  type        = string
  description = "The project ID for the enabler environment and project."
  default     = "org-enabler"
}

variable "cloudbuild_project_id" {
  type        = string
  description = "The project ID for the cloudbuild project."
  default     = "org-cloudbuild"
}

variable "dominikjaro_prod_project_id" {
  type        = string
  description = "The project ID for the dominikjaro production project."
  default     = "dominikjaro-prod"
}

variable "dominikjaro_dev_project_id" {
  type        = string
  description = "The project ID for the dominikjaro development project."
  default     = "dominikjaro-dev"
}

variable "env" {
  type        = string
  description = "The environment to deploy to."
}
