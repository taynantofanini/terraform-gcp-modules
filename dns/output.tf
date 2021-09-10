output "name-servers" {
  value = google_dns_managed_zone.dns-zone.name_servers
}

output "dns_name" {
  value = google_dns_managed_zone.dns-zone.dns_name
}