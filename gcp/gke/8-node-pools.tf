# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "private" {
  name       = "private"
  cluster    = google_container_cluster.private.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-standard-2"
    disk_size_gb = 50

    labels = {
      role = "private"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}



# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "public" {
  name       = "public"
  cluster    = google_container_cluster.public.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }


  node_config {
    preemptible  = false
    machine_type = "e2-small"
    disk_size_gb = 50
    
    labels = {
      role = "public"
    }
    

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
