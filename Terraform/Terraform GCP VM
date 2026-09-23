terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

variable "project_id" {
  description = "GCP project ID used for the security compliance environment"
  type        = string
}

resource "google_compute_network" "security_network" {
  name                    = "security-compliance-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "workload" {
  name          = "security-compliance-subnet"
  ip_cidr_range = "10.20.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.security_network.id
}

resource "google_compute_instance" "linux_vm" {
  name         = "security-compliance-linux-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.workload.id
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  tags = ["security-compliance"]
}
