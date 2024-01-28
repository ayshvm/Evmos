# Create a Google Compute Engine instance (bastion VM) in the public subnet
resource "google_compute_instance" "bastion" {
  name         = "bastion-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"  

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public.self_link
    access_config {}
  }

  tags = ["bastion"]
  allow_stopping_for_update = true
}

# Create a firewall rule to allow SSH traffic
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh-bastion"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # Allowing SSH access from any IP address. Adjust as per your security requirements.
  target_tags   = ["bastion"]     # Apply the firewall rule to instances with the "bastion" tag.
}


resource "google_compute_firewall" "egress-all" {
  name    = "allow-egress-all"
  network = google_compute_network.main.self_link

  allow {
    protocol = "all"  # All protocols
  }

  source_ranges      = ["0.0.0.0/0"]
  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["bastion"]
}
