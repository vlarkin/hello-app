resource "google_artifact_registry_repository" "docker_registry" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = "docker-registry"
  description   = "A private docker images registry"
  format        = "DOCKER"

  depends_on = [
    google_project_service.artifactregistry
  ]

}
