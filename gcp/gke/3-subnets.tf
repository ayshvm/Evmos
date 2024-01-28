# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name                     = "private"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = "us-central1"
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

# Create the public subnet
resource "google_compute_subnetwork" "public" {
  name                     = "public"
  ip_cidr_range            = "10.0.64.0/18"  
  region                   = "us-central1"
  network                  = google_compute_network.main.id
  private_ip_google_access = true  

  secondary_ip_range {
    range_name    = "k8s-pod-range-public"
    ip_cidr_range = "10.64.0.0/14"  
  }
  secondary_ip_range {
    range_name    = "k8s-service-range-public"
    ip_cidr_range = "10.68.0.0/20"  
  }

  
}
