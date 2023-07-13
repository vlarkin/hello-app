resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

resource "google_project_iam_member" "kubernetes" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.kubernetes.email}"
}

resource "google_container_cluster" "applications" {
  name                     = "applications"
  location                 = "${var.region}-b"
  remove_default_node_pool = false
  initial_node_count       = var.gke_num_nodes
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  node_locations = [
    "${var.region}-c"
  ]

  node_config {
    preemptible  = true
    machine_type = var.gke_machine_type
    disk_size_gb = 10
    disk_type = "pd-standard"

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.gke_master_ip_range
  }
}
