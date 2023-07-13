output "GCP_PROJECT_ID" {
  value       = var.project_id
  description = "GCP_PROJECT_ID"
}

output "GCP_REGION" {
  value       = var.region
  description = "GCP_REGION"
}

output "GKE_CLUSTER_NAME" {
  value       = google_container_cluster.applications.name
  description = "GKE_CLUSTER_NAME"
}

output "GKE_CLUSTER_ZONE" {
  value       = google_container_cluster.applications.location
  description = "GKE_CLUSTER_ZONE"
}

output "GCP_WORKFLOW_SA" {
  value       = google_service_account.github_actions_workflow.email
  description = "GCP_WORKFLOW_SA"
}

output "GCP_WORKLOAD_IDENTITY" {
  value       = google_iam_workload_identity_pool_provider.github_actions_oidc.name
  description = "GCP_WORKLOAD_IDENTITY"
}

output "DOCKER_REGISTRY_NAME" {
  value       = google_artifact_registry_repository.docker_registry.name
  description = "DOCKER_REGISTRY_NAME"
}
