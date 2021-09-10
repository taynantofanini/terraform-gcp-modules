output "name-servers" {
  value = google_dns_managed_zone.laghetto-zone.name_servers
}

output "dns_name" {
  value = google_dns_managed_zone.laghetto-zone.dns_name
}