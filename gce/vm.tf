resource "google_compute_address" "external-ip-tf" {
  for_each = var.vms
  name     = "${each.value.name}-external"
  region   = each.value.region
}

resource "google_compute_instance" "vm-tf" {
  depends_on   = [google_compute_subnetwork.subnetwork-tf]
  for_each     = var.vms
  project      = var.project
  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    device_name = "${each.value.name}-disk"

    initialize_params {
      image = each.value.disk_image
      size  = each.value.disk_size
      type  = each.value.disk_type
    }
  }

  network_interface {
    network    = google_compute_network.network-tf.name
    subnetwork = each.value.subnet
    access_config {
      nat_ip = google_compute_address.external-ip-tf["${each.key}"].address
    }
  }
  
  labels = {
    "vm" = "${each.value.name}"
  }

}
