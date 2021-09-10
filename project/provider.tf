provider "google" {
  user_project_override = true
  billing_project       = google_project.customer-project.project_id
  alias                 = "provider-billing"
}
