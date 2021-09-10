resource "google_compute_vpn_gateway" "gcp" {
  name    = "${var.customer_name}-gateway"
  network = var.gcp_network
  region  = var.gcp_region
}

resource "google_compute_address" "vpn-external" {
  name   = "vpn-external"
  region = var.gcp_region
}

resource "google_compute_forwarding_rule" "fr-esp" {
  name        = "fr-esp"
  region      = var.gcp_region
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn-external.address
  target      = google_compute_vpn_gateway.gcp.self_link
}

resource "google_compute_forwarding_rule" "fr-udp500" {
  name        = "fr-udp500"
  region      = var.gcp_region
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = google_compute_address.vpn-external.address
  target      = google_compute_vpn_gateway.gcp.self_link
}

resource "google_compute_forwarding_rule" "fr-udp4500" {
  name        = "fr-udp4500"
  region      = var.gcp_region
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = google_compute_address.vpn-external.address
  target      = google_compute_vpn_gateway.gcp.self_link
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  name                   = "${var.customer_name}-tunnel-1"
  ike_version            = "2"
  region                 = var.gcp_region
  peer_ip                = var.peer_ip1
  shared_secret          = random_password.password.result
  local_traffic_selector = ["0.0.0.0/0"]

  target_vpn_gateway = google_compute_vpn_gateway.gcp.self_link

  depends_on = [
    google_compute_forwarding_rule.fr-esp,
    google_compute_forwarding_rule.fr-udp500,
    google_compute_forwarding_rule.fr-udp4500
  ]
}

resource "google_compute_route" "gcp_route1" {
  name       = "gcp-route1"
  network    = var.gcp_network
  dest_range = var.peer_cidr
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel1.self_link
}

resource "google_compute_firewall" "peer-vpn" {
  name          = "allow-all-vpn"
  network       = var.gcp_network
  source_ranges = var.source_ranges_vpn

  allow {
    protocol = "all"
  }
}

resource "random_password" "password" {
  length  = 16
  special = true
}


