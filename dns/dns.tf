resource "google_dns_managed_zone" "laghetto-zone" {
  name        = var.zone_name
  dns_name    = var.dns_name
  description = "managed-by-terraform"
  labels = {
    managedby = "terraform"
  }
}

resource "google_dns_record_set" "laghetto-record" {
  project      = var.project
  managed_zone = google_dns_managed_zone.laghetto-zone.name
  name         = var.dns_name
  type         = "A"
  rrdatas      = [var.external_lb_ip]
  ttl          = 300
}

resource "google_dns_record_set" "laghetto-record-cname" {
  project      = var.project
  managed_zone = google_dns_managed_zone.laghetto-zone.name
  name         = "www.${var.dns_name}"
  type         = "A"
  rrdatas      = [var.external_lb_ip]
  ttl          = 300
}
