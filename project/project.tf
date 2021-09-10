#Cria uma pasta dentro da pasta "Clientes SD" e um projeto dentro dessa nova pasta e ativa as apis necessárias para criar o budget através do projeto

resource "google_folder" "customer-folder" {
  display_name = var.customer_name
  parent       = "folders/641848800381"
}

resource "google_project" "customer-project" {
  name                = var.project_name
  project_id          = var.project_id
  folder_id           = google_folder.customer-folder.name
  billing_account     = google_billing_subaccount.subaccount.billing_account_id
  auto_create_network = false
  labels = {
    managedby = "terraform"
  }
}

resource "google_project_service" "billing-api" {
  depends_on                 = [google_project.customer-project]
  project                    = google_project.customer-project.project_id
  service                    = "billingbudgets.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "api" {
  depends_on                 = [google_project.customer-project]
  project                    = google_project.customer-project.project_id
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "api2" {
  depends_on                 = [google_project.customer-project]
  project                    = google_project.customer-project.project_id
  service                    = "serviceusage.googleapis.com"
  disable_dependent_services = true
}
