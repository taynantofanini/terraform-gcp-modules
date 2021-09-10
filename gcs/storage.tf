resource "google_storage_bucket" "bucket-lifecycle" {
  project       = var.project_id
  name          = var.bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  force_destroy = true

  retention_policy {
    is_locked        = true
    retention_period = ((86400 - (0.95 * 86400)) * var.lifecycle_age)
  }

  lifecycle_rule {

    condition {
      age = var.lifecycle_age #in days
    }
    action {
      type          = var.action_type #delete or setstorageclass
      storage_class = var.action_type == "SetStorageClass" ? var.target_storage : null
    }
  }
  labels = {
    managedby = "terraform"
  }
}
