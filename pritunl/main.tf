resource "google_compute_address" "external-ip-pritunl" {
  name   = "pritunl-vpn-server-external"
  region = var.region
}

resource "google_compute_instance" "pritunl-instance" {
  name                    = "pritunl-vpn-server"
  machine_type            = "e2-small"
  zone                    = var.zone
  metadata_startup_script = file("${path.module}/install.sh")

  boot_disk {
    device_name = "pritunl-vpn-server-disk"

    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "10"
      type  = "pd-balanced"
    }

  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      nat_ip = google_compute_address.external-ip-pritunl.address
    }

  }

  tags = ["http-server", "https-server"]

  labels = {
    "vm"        = "pritunl-vpn-server"
    "managedby" = "terraform"
  }

}
