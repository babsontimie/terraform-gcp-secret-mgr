resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "tf_state" {
  name          = "tfstate-gcp-secrmgr-${random_id.suffix.hex}"
  location      = var.bucket_location
  force_destroy = true

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

output "bucket_name" {
  value = google_storage_bucket.tf_state.name
}
