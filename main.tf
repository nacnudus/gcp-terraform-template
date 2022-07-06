# Adapted from https://medium.com/rockedscience/how-to-fully-automate-the-deployment-of-google-cloud-platform-projects-with-terraform-16c33f1fb31f

# ========================================================
# Create Google Cloud Projects from scratch with Terraform
# ========================================================
#
# This script is a workaround to fix an issue with the
# Google Cloud Platform API that prevents to fully
# automate the deployment of a project _from scratch_
# with Terraform, as described here:
# https://stackoverflow.com/questions/68308103/gcp-project-creation-via-api-doesnt-enable-service-usage-api
# It uses the `gcloud` CLI:
# https://cloud.google.com/sdk/gcloud
# in the pipeline. The `gcloud` CLI therefore needs to be
# installed and provided with sufficient credentials to
# consume the API.
# Full article:
# https://medium.com/rockedscience/how-to-fully-automate-the-deployment-of-google-cloud-platform-projects-with-terraform-16c33f1fb31f

# Set variables to reuse them across the resources
# and enforce consistency.
variable project_id {
  type        = string
  default     = "my-test-project" # Change this
}

# Change this once you know it, and uncomment the billing_account line below
variable billing_account {
  type        = string
  default     = "000000-000000-000000" # Change this
}

variable folder_id {
  type        = string
  default     = "000000000000" # Change this
}

variable region {
  type        = string
  default     = "europe-west2" # Change this
}

variable zone {
  type        = string
  default     = "europe-west2-a" # Change this
}

variable services {
  type        = list
  default     = [
    # List all the services you use here
    # "bigquery.googleapis.com"
  ]
}

# Set the Terraform provider
provider "google" {
  project               = var.project_id
  region                = var.region
  zone                  = var.zone

  # Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#user_project_override
  user_project_override = true
}

# Create the project
resource "google_project" "project" {
  # billing_account     = var.billing_account # Uncomment once known
  folder_id             = var.folder_id
  name                  = var.project_id
  project_id            = var.project_id
}

# Use `gcloud` to enable:
# - serviceusage.googleapis.com
# - cloudresourcemanager.googleapis.com
resource "null_resource" "enable_service_usage_api" {
  provisioner "local-exec" {
    command = "gcloud services enable serviceusage.googleapis.com cloudresourcemanager.googleapis.com --project ${var.project_id}"
  }

  depends_on = [google_project.project]
}

# Enable other services used in the project
resource "google_project_service" "services" {
  for_each = toset(var.services)

  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false

}

# # Add a resource (just a demo, change as needed)
# resource "google_bigquery_dataset" "my_test_dataset" {
#   dataset_id                  = "my_test_dataset"
#   location                    = var.region
#
#   # Note the dependency, add this to every resource
#   # you create with Terraform
#   depends_on = [google_project_service.services]
# }
