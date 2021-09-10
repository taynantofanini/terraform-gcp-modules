resource "google_compute_global_address" "private_ip_address" {
  provider      = google-beta
  name          = "private-ip-mysql"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network
}

resource "google_service_networking_connection" "private_vpc_connection" {
  depends_on = [google_project_service.api-network]
  provider                = google-beta
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_project_service" "api-network" {
  project                    = var.project
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = true
}