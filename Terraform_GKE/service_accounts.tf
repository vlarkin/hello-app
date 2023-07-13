
resource "google_service_account" "myapp_dev" {
  account_id = "myapp-dev"
}

resource "google_service_account" "pyapp_dev" {
  account_id = "pyapp-dev"
}

resource "google_service_account_iam_member" "myapp_dev" {
  service_account_id = google_service_account.myapp_dev.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[dev/myapp]"
}

resource "google_service_account_iam_member" "pyapp_dev" {
  service_account_id = google_service_account.pyapp_dev.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[dev/pyapp]"
}
