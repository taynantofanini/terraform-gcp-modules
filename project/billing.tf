resource "google_monitoring_notification_channel" "notification_channel" {
  project      = google_project.customer-project.project_id
  display_name = "Send email to ${var.email_budget_alert}"
  type         = "email"
  labels = {
    email_address = var.email_budget_alert
  }
}

resource "google_billing_subaccount" "subaccount" {
  display_name           = "${var.customer_name}-Santo"
  master_billing_account = "01793C-DD135C-4E4C41" #Santo Digital Master Billing Account ID
}

# resource "google_billing_account_iam_member" "owner" {
#   billing_account_id = google_billing_subaccount.subaccount.id
#   role               = "roles/billing.owner"
#   for_each           = toset(var.billing-owner)
#   member             = "user:${each.key}"
# }

resource "google_billing_budget" "budget" {
  depends_on      = [google_project_service.billing-api]
  provider        = google.provider-billing
  billing_account = google_billing_subaccount.subaccount.billing_account_id
  display_name    = "Budget-${var.project_name}"

  budget_filter {
    projects = [google_project.customer-project.id]
  }

  amount {
    specified_amount {
      currency_code = "BRL"
      units         = var.budget_limit
    }
  }

  threshold_rules {
    threshold_percent = 1.0
  }
  threshold_rules {
    threshold_percent = 0.9
  }
  threshold_rules {
    threshold_percent = 0.5
  }
  threshold_rules {
    threshold_percent = 0.25
  }

  all_updates_rule {
    monitoring_notification_channels = [google_monitoring_notification_channel.notification_channel.name,]
  }

}
