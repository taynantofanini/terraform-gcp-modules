resource "google_compute_firewall" "firewall-tf" {
  depends_on    = [google_compute_network.network-tf]
  for_each      = var.firewalls
  project       = var.project
  network       = google_compute_network.network-tf.id
  description   = "Created by terraform"
  name          = each.value.name
  source_ranges = each.value.source_ranges

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

  target_tags = each.value.target_tags
}
