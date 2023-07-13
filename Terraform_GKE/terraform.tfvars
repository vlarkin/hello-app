project_id = "triple-nectar-391006"
region     = "europe-west1"
#
gke_num_nodes    = 1
gke_machine_type = "e2-small"
#
vpc_ip_range         = "10.0.0.0/18"
gke_pod_ip_range     = "10.48.0.0/14"
gke_service_ip_range = "10.52.0.0/20"
gke_master_ip_range  = "172.16.0.0/28"
#
github_repository_name = "vlarkin/hello-apps"
