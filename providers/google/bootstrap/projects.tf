module "demo" {
  source = "../../../modules/google/project-creation"

  billing_account = "${var.billing_account}"
  project_name    = "sr-test"
  bucket          = "${var.tf_project_name}"
  region          = "europe-west1"
  folder_name     = "${google_folder.test.name}"

  services = ["bigquery-json.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "composer.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudtrace.googleapis.com",
    "deploymentmanager.googleapis.com",
    "dns.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "redis.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "sqladmin.googleapis.com",
    "stackdriverprovisioning.googleapis.com",
    "storage-component.googleapis.com",
    "stackdriver.googleapis.com",
    "storage-api.googleapis.com",
  ]
}
