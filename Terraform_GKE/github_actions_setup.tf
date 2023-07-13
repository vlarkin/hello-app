resource "google_service_account" "github_actions_workflow" {
  project = var.project_id
  account_id   = "github-actions-workflow"
  display_name = "GitHub Actions workflow"
}

resource "google_project_iam_member" "github_actions_workflow" {
  project = var.project_id
  for_each = toset([
    "roles/artifactregistry.writer",
    "roles/container.developer"
  ])
  role = each.key
  member  = "serviceAccount:${google_service_account.github_actions_workflow.email}"
}

resource "google_iam_workload_identity_pool" "github_actions" {
  project  = var.project_id
  provider = google-beta
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
  description               = "GitHub Actions tutorial"
}

resource "google_iam_workload_identity_pool_provider" "github_actions_oidc" {
  project  = var.project_id
  provider = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-oidc"
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC identity pool provider for execute GitHub Actions"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.owner"      = "assertion.repository_owner"
    "attribute.refs"       = "assertion.ref"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_actions_workflow" {
  service_account_id = google_service_account.github_actions_workflow.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/${var.github_repository_name}"
}
