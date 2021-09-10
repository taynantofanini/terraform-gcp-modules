resource "google_compute_network" "network-tf" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork-tf" {
  depends_on    = [google_compute_network.network-tf]
  network       = google_compute_network.network-tf.id
  for_each      = var.subnets
  name          = each.value.name
  ip_cidr_range = each.value.range
  region        = each.value.region
}
