
#!/usr/bin/env bash

PROJECT="tee-ghactions"
SECRETS=("terraform_sa" "db-password" "api-key")

echo "🔍 Starting checklist for project: $PROJECT"

# 1. Ensure project is set
CURRENT=$(gcloud config get-value project 2>/dev/null)
if [ "$CURRENT" != "$PROJECT" ]; then
  echo "❗ gcloud project is set to: $CURRENT"
  echo "🔧 Setting project to $PROJECT"
  gcloud config set project $PROJECT
fi

for SECRET in "${SECRETS[@]}"; do
  echo "----"
  echo "Checking secret container: $SECRET"

  # 2. List secret containers
  CONTAINERS=$(gcloud secrets list --format="value(NAME)" --project=$PROJECT)
  if echo "$CONTAINERS" | grep -q "^${SECRET}$"; then
    echo "✅ Secret container exists: $SECRET"
  else
    echo "❗ Secret container DOES NOT exist: $SECRET"
    echo "   ➤ You may need to create it or change the secret_id in Terraform."
  fi

  # 3. List versions
  VERSIONS=$(gcloud secrets versions list $SECRET --project=$PROJECT --format="value(VERSION)")
  if [ -z "$VERSIONS" ]; then
    echo "❗ No versions found for secret: $SECRET"
    echo "   ➤ You need to add at least one version (upload the secret value) before using it."
  else
    echo "✅ Versions exist for secret $SECRET: $VERSIONS"
  fi

  # 4. Check Terraform import status
  TF_RESOURCE="google_secret_manager_secret.${SECRET//-/_}"   # simple mapping: dash→underscore
  # Note: This assumes your resource blocks use names like terraform_sa, db_password, api_key
  echo "➤ Checking Terraform state for resource: $TF_RESOURCE"
  if terraform state list | grep -q "^${TF_RESOURCE}$"; then
    echo "✅ Terraform state contains: $TF_RESOURCE"
  else
    echo "❗ Terraform state does *NOT* contain: $TF_RESOURCE"
    echo "   ➤ You should run: terraform import $TF_RESOURCE projects/$PROJECT/secrets/$SECRET"
  fi

  echo ""
done

echo "----"
echo "📋 After this: Make sure your Terraform config uses the correct `secret_id`, and for each secret you either import the container *and* ensure a version exists or you let Terraform manage creation + versioning consistently."
echo "✅ Checklist done."
