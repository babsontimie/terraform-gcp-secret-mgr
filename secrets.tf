# Create secrets in Secret Manager
resource "google_secret_manager_secret" "terraform_sa" {
  secret_id = "terraform-service-account"
  replication {
    automatic = {}
  }
}

resource "google_secret_manager_secret_version" "terraform_sa_version" {
  secret      = google_secret_manager_secret.terraform_sa.id
  secret_data = file("service-account.json")
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password"
  replication {
    automatic = {}
  }
}

resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = file("db_password.txt")
}

resource "google_secret_manager_secret" "api_key" {
  secret_id = "api-key"
  replication {
    automatic = {}
  }
}

resource "google_secret_manager_secret_version" "api_key_version" {
  secret      = google_secret_manager_secret.api_key.id
  secret_data = file("api_key.txt")
}

# Read the Terraform service account secret using bootstrap provider
data "google_secret_manager_secret_version" "terraform_sa_key" {
  provider = google.bootstrap
  project  = var.project_id
  secret   = google_secret_manager_secret.terraform_sa.secret_id
  version  = "latest"
}
