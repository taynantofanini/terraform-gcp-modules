provider "google-beta" {
  project = var.project
  alias   = "google-beta"
}

provider "google" {
  project = var.project
}
