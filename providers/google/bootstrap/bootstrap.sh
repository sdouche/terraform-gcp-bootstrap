#!/usr/bin/env bash

set -e

source <(grep = terraform.tfvars | sed 's/ *= */=/g')
source ../../../lib/utils.sh

credentials=$HOME/.config/gcloud/${tf_project_name}.json

e_header "Create the Admin Project"
e_arrow "Create a new project"
gcloud projects create ${tf_project_name} \
	--organization ${org_id} \
	--set-as-default

e_arrow "Link it to the billing account"
gcloud beta billing projects link ${tf_project_name} \
	--billing-account ${billing_account}

e_header "Create the Service Account"
e_arrow "Create the service account"
gcloud iam service-accounts create terraform \
	  --display-name "Terraform admin account"

e_arrow "Download the JSON credentials"
gcloud iam service-accounts keys create ${credentials} \
	  --iam-account terraform@${tf_project_name}.iam.gserviceaccount.com

e_header "Grant the service account to the Admin Project"
e_arrow "Grant the service account permission to view the Admin Project"
gcloud projects add-iam-policy-binding ${tf_project_name} \
	  --member serviceAccount:terraform@${tf_project_name}.iam.gserviceaccount.com \
	  --role roles/viewer

e_arrow "Grant the service account permission to manage Cloud Storage"
gcloud projects add-iam-policy-binding ${tf_project_name} \
	  --member serviceAccount:terraform@${tf_project_name}.iam.gserviceaccount.com \
	  --role roles/storage.admin

e_header "Enable APIs"
e_arrow "Enable Cloud Deployment Manager V2 API"
gcloud services enable deploymentmanager.googleapis.com

e_arrow "Enable Cloud Resource Manager API"
gcloud services enable cloudresourcemanager.googleapis.com

e_arrow "Enable Service Management API"
gcloud services enable servicemanagement.googleapis.com

e_arrow "Enable Cloud Billing API"
gcloud services enable cloudbilling.googleapis.com

e_arrow "Enable IAM API"
gcloud services enable iam.googleapis.com

e_header "Grant the Service Account permission"
e_arrow "Grant the service account permission to create projects"
gcloud organizations add-iam-policy-binding ${org_id} \
	  --member serviceAccount:terraform@${tf_project_name}.iam.gserviceaccount.com \
	  --role roles/resourcemanager.projectCreator

e_arrow "Grant the service account permission to assign billing accounts"
gcloud organizations add-iam-policy-binding ${org_id} \
	  --member serviceAccount:terraform@${tf_project_name}.iam.gserviceaccount.com \
	  --role roles/billing.user

e_header "Create the bucket with versioning"
gsutil mb -l eu -p ${tf_project_name} gs://${tf_project_name}
gsutil versioning set on gs://${tf_project_name}

e_header "Create the backend.tf file for storage states"
cat > backend.tf <<EOF
terraform {
 backend "gcs" {
    credentials = "${credentials}"
    project = "${tf_project_name}"
    bucket  = "${tf_project_name}"
    prefix   = "/terraform.tfstate"
  }
}
EOF

e_header "END"
