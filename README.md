build a complete Terraform setup that does all of this:

Creates a GCS bucket for Terraform state (backend).

Creates Google Secret Manager secrets (for your service account key, DB password, API key).

Stores your service account key securely in Secret Manager.

Authenticates Terraform’s Google provider using that secret.

Uses that authenticated provider to manage all GCP resources.

This will be a production-grade, fully managed, and reproducible setup.

```terraform/
├── backend-bootstrap/     # Step 1: creates the GCS bucket for backend
│   ├── main.tf
│   └── variables.tf
└── main/                  # Step 2: main Terraform config using the bucket + secrets
    ├── main.tf
    ├── secrets.tf
    ├── providers.tf
    ├── variables.tf
    └── outputs.tf


 ```
 🪄 Usage
1️⃣ Create the backend bucket
cd backend-bootstrap
terraform init
terraform apply

2️⃣ Initialize main Terraform
cd ../main
terraform init
terraform plan
terraform apply


Terraform will:

Use ADC to create and populate secrets.

Read the Terraform SA key from Secret Manager.

Re-authenticate using that SA key.

Create your resources securely.

🧠 Key Takeaways

✅ Secrets and passwords are never hardcoded — always stored in Secret Manager.
✅ Backend bucket is automatically created.
✅ Terraform itself authenticates via the service account stored securely in Secret Manager.
✅ Clean separation of bootstrap and main phases prevents dependency cycles.
✅ Works in both local and CI/CD (GitHub Actions, GitLab, etc.) environments.


```Section 2 - Secret Manager setup extended  to GitHub Actions
-------------------------------------------------------------

I will take the secure Terraform + GCS backend + Secret Manager setup and extend it to GitHub Actions, so that:

Terraform runs automatically in CI/CD.

GitHub never stores or sees your service account key file.

The workflow authenticates securely to Google Cloud.

Secrets are pulled directly from Google Secret Manager at runtime.

🧠 Overview of What We’ll Build

✅ GitHub Actions workflow (.github/workflows/terraform.yml) that:

Authenticates to Google Cloud using Workload Identity Federation (WIF) (no JSON keys needed).

Runs Terraform in the main/ directory using the GCS backend.

Uses Terraform code that reads all secrets (service account key, DB password, API key) from Secret Manager.

🪣 Why Workload Identity Federation (WIF)

WIF lets GitHub authenticate directly to Google Cloud without storing any static JSON key.
It works by linking:

A Google Cloud Service Account (Terraform runner)

A Workload Identity Pool

A GitHub repository identity provider

This is now the recommended secure method by Google Cloud.

```