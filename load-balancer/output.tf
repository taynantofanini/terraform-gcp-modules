output "lb-external-ip" {
  value = google_compute_global_address.external-ip-lb.address
}
