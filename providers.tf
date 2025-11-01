terraform {
  backend "gcs" {
    bucket = "tfstate-gcp-secrmgr-6e842a42" # Replace with your output bucket name
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

# Bootstrap provider (uses ADC for reading secrets)
provider "google" {
  alias   = "bootstrap"
  project = var.project_id
  region  = var.region
}
