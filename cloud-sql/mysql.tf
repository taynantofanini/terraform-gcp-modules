resource "google_sql_database_instance" "instance" {
  depends_on = [google_service_networking_connection.private_vpc_connection]
  provider   = google-beta

  database_version    = var.sql_version
  deletion_protection = true
  name                = var.sql_name
  region              = var.sql_region

  settings {
    availability_type = var.availability_type
    disk_autoresize   = var.autoresize
    disk_size         = var.disk_size
    disk_type         = var.disk_type
    tier              = var.machine_type

    backup_configuration {
      binary_log_enabled = true #For MYSQL instance, set true
      enabled            = true #For MYSQL instance, set true
      location           = var.sql_region
      start_time         = "04:00"

      backup_retention_settings {
        retained_backups = "30"
        retention_unit   = "COUNT"
      }
    }

    maintenance_window {
      day          = 7
      hour         = 03
      update_track = "stable"
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network
    }
  }
}

resource "random_password" "password" {
  length  = 16
  special = true
}

resource "google_sql_user" "users" {
  name     = "root"
  instance = google_sql_database_instance.instance.name
  password = random_password.password.result
  project  = var.project
}

