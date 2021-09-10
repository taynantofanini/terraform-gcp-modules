variable "peer_ip1" {
  description = "VPN Peer IP"
}

variable "peer_cidr" {
  description = "CIDR group from peer network"
}

variable "gcp_cidr" {
  description = "CIDR group for GCP network"
}

variable "gcp_network" {
  description = "Network name for GCP"
}

variable "gcp_region" {
  description = "Region for GCP"
}

variable "customer_name" {
  description = "Customer Name"
}

variable "source_ranges_vpn" {
  description = "source_ranges-vpn"
}

variable "project" {
}

variable "vpn_power" {
  type = string
}

