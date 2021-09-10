resource "google_dns_managed_zone" "dns-zone" {
  name     = var.zone_name
  dns_name = var.dns_name
  labels = {
    managedby = "terraform"
  }
}

resource "google_dns_record_set" "dns-record" {
  for_each     = var.record_set
  managed_zone = google_dns_managed_zone.google_dns_managed_zonedns-zone.name
  name         = each.value.name
  type         = each.value.type
  rrdatas      = each.value.rrdatas
  ttl          = each.value.ttl
}

