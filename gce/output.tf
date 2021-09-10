output "vpc-name" {
  value = google_compute_network.network-tf.id
}

# output "subnet-region" {
#   value = google_compute_subnetwork.subnetwork-tf.region
# }

output "subnet-region" {
  value = toset([
    for subnet in google_compute_subnetwork.subnetwork-tf : subnet.region
  ])
}

# output "subnet-ip-range" {
#   value = google_compute_subnetwork.subnetwork-tf.ip_cidr_range
# }

output "subnet-ip-range" {
  value = toset([
    for range in google_compute_subnetwork.subnetwork-tf : range.ip_cidr_range
  ])
}