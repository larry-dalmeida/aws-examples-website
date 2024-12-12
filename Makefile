# Define variables
TERRAFORM_DIR := deploy

# Phony targets
.PHONY: help tf-init tf-plan tf-apply tf-destroy

# Default target
help:  ## Display this help message
	@echo "Usage: make [TARGET]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

setup: # Set up the environment
	chmod +x scripts/*.sh

tf-init:  ## Initialize Terraform
	@echo "Initializing Terraform in $(TERRAFORM_DIR)..."
	cd $(TERRAFORM_DIR) && terraform init

tf-plan:  ## Generate and show an execution plan
	@echo "Generating Terraform plan in $(TERRAFORM_DIR)..."
	cd $(TERRAFORM_DIR) && terraform plan

tf-apply:  ## Apply the Terraform configuration
	@echo "Applying Terraform configuration in $(TERRAFORM_DIR)..."
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve

tf-destroy:  ## Destroy the Terraform-managed infrastructure
	@echo "Destroying Terraform-managed infrastructure in $(TERRAFORM_DIR)..."
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve

tf-reset: ## Destroy and re-apply Terraform-managed infra
	@echo "Destroying Terraform-managed infrastructure in $(TERRAFORM_DIR)..."
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve
	@echo "Applying Terraform configuration in $(TERRAFORM_DIR)..."
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve