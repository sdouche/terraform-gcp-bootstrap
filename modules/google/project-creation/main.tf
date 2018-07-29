resource "random_id" "id" {
  byte_length = 2
  prefix      = "${var.project_name}-"
}

resource "google_project" "project" {
  billing_account = "${var.billing_account}"
  folder_id       = "${var.folder_name}"
  project_id      = "${random_id.id.hex}"
  name            = "${var.project_name}"
}

resource "google_project_services" "project" {
  project = "${google_project.project.project_id}"

  services = ["${var.services}"]
}

resource "google_storage_bucket" "bucket" {
  name          = "${random_id.id.hex}"
  project       = "${var.bucket}"
  location      = "EU"
  force_destroy = true

  versioning {
    enabled = true
  }
}
