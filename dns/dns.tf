resource "google_dns_managed_zone" "dns-zone" {
  provider = google.google
  name     = var.zone_name
  dns_name = var.dns_name
  labels = {
    managedby = "terraform"
  }
}

resource "google_dns_record_set" "dns-record" {
  for_each     = var.record_set
  provider     = google-beta.google-beta
  managed_zone = google_dns_managed_zone.google_dns_zone.name
  name         = each.value.name
  type         = each.value.type
  rrdatas      = each.value.rrdatas
  ttl          = each.value.ttl
}

