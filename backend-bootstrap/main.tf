terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.9.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

