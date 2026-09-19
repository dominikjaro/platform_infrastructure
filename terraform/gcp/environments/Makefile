# Makefile for environments

# Define the environment
env ?= default

# Initialize the environment
init:
	cd $(env) && terraform init -backend-config=./backend.hcl


# Validate and initialize the environment
validate:
	cd $(env) && terraform init -backend-config=./backend.hcl
	cd $(env) && terraform fmt -recursive
	cd $(env) && terraform validate

# Plan the environment
plan:
	cd $(env) && terraform init -backend-config=./backend.hcl
	cd $(env) && terraform fmt -recursive
	cd $(env) && terraform plan -var-file=./terraform.tfvars

# Apply the environment
apply:
	cd $(env) && terraform init -backend-config=./backend.hcl
	cd $(env) && terraform fmt -recursive
	cd $(env) && terraform apply -var-file=./terraform.tfvars

.PHONY: init validate plan apply
