provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket  = "triple-nectar-391006-terraform"
    prefix  = "gke-tf-state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }
  required_version = ">= 0.14"
}
