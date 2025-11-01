# Google provider authenticated via secret manager service account
provider "google" {
  #credentials = base64decode(data.google_secret_manager_secret_version.terraform_sa_key.secret_data)
  project = var.project_id
  region  = var.region
}

# Example: use db password secret
data "google_secret_manager_secret_version" "db_password" {
  project = var.project_id
  secret  = google_secret_manager_secret.db_password.secret_id
  version = "latest"
}

# Example: use API key secret
data "google_secret_manager_secret_version" "api_key" {
  project = var.project_id
  secret  = google_secret_manager_secret.api_key.secret_id
  version = "latest"
}

# Example resource: Cloud SQL user
# resource "google_sql_user" "app_user" {
#   name     = "appuser"
#   instance = "my-sql-instance"
#   password = data.google_secret_manager_secret_version.db_password.secret_data
# }

# Example: metadata injection with API key
resource "google_compute_instance" "example" {
  name         = "example-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
  }

  metadata = {
    api_key = data.google_secret_manager_secret_version.api_key.secret
  }
}
