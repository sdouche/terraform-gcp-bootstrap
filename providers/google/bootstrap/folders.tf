resource "google_folder" "demo" {
  display_name = "Demo"
  parent       = "organizations/${var.org_id}"
}
